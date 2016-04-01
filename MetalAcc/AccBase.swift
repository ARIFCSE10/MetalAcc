//
//  AccBase.swift
//  MetalAcc
//
//  Created by 王佳玮 on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

import MetalKit
public class AccBase{
    public var device:MTLDevice? = nil
    public var library:MTLLibrary? = nil
    public var commandQueue:MTLCommandQueue? = nil
    public init(){
        device = MTLCreateSystemDefaultDevice()
        library = self.device!.newDefaultLibrary()
        commandQueue = self.device!.newCommandQueue()
    }
}