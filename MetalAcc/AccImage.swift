//
//  AccImage.swift
//  MetalAcc
//
//  Created by 王佳玮 on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

import MetalKit
public class AccImage:AccBase{
    
    public let threadGroupCount = MTLSizeMake(16, 16, 1)
    public var inTexture: MTLTexture? = nil
    public var outTexture: MTLTexture? = nil
    public var pipelineState: MTLComputePipelineState? = nil
    public var threadGroups: MTLSize? = nil
    public var filter:AccImageFilter? = nil
    
    override public init() {
        super.init()
    }
    
    public func AddImage(image:UIImage){
        inTexture = textureFromImage(image)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(inTexture!.pixelFormat, width: inTexture!.width, height: inTexture!.height, mipmapped: false)
        outTexture = self.device!.newTextureWithDescriptor(textureDescriptor)
        threadGroups = MTLSizeMake(Int(self.inTexture!.width) / self.threadGroupCount.width, Int(self.inTexture!.height) / self.threadGroupCount.height, 1)
    }
    
    public func AddFilter(filter:AccImageFilter){
        if let function = self.library!.newFunctionWithName(filter.name!){
        do {
            self.pipelineState = try device!.newComputePipelineStateWithFunction(function)
        }
        catch {
            fatalError("Unable to setup Metal")
        }
        }else{
            fatalError("Unable to load library")
        }
        self.filter = filter
        self.filter?.base = self
    }
    
    public func Processing()->UIImage{
        self.filter?.applyFilter()
        return imageFromTexture(self.outTexture!)
    }

    private func textureFromImage(image: UIImage) -> MTLTexture {
        let imageRef: CGImageRef = image.CGImage!
        let width: Int = CGImageGetWidth(imageRef)
        let height: Int = CGImageGetHeight(imageRef)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let rawData  = malloc(height * width * 4)//byte
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
    
        let bitmapContext: CGContextRef = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, (CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue))!
        
        // Flip the context so the positive Y axis points down
        CGContextTranslateCTM(bitmapContext, 0, CGFloat(height))
        CGContextScaleCTM(bitmapContext, 1, -1)
        CGContextDrawImage(bitmapContext,CGRect(x: 0, y: 0,width: CGFloat(width), height: CGFloat(height)),imageRef)
        
        let textureDescriptor: MTLTextureDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.RGBA8Unorm, width: width, height: height, mipmapped: false)
        let texture: MTLTexture = self.device!.newTextureWithDescriptor(textureDescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture.replaceRegion(region, mipmapLevel: 0, withBytes: rawData, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
        
    }
    
    private func imageFromTexture(texture: MTLTexture) -> UIImage {
        let bytesPerPixel: Int = 4
        let imageByteCount = texture.width * texture.height * bytesPerPixel
        let bytesPerRow = texture.width * bytesPerPixel
        var src = [UInt8](count: Int(imageByteCount), repeatedValue: 0)
        
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(&src, bytesPerRow: bytesPerRow, fromRegion: region, mipmapLevel: 0)
        
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue))
        
        let grayColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let context = CGBitmapContextCreate(&src, texture.width, texture.height, bitsPerComponent, bytesPerRow, grayColorSpace, bitmapInfo.rawValue);
        
        let dstImageFilter = CGBitmapContextCreateImage(context);
        
        return UIImage(CGImage: dstImageFilter!, scale: 0.0, orientation: UIImageOrientation.DownMirrored)
    }
    
}