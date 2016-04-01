//
//  AccBrightnessFilter.swift
//  MetalAcc
//
//  Created by 王佳玮 on 16/4/1.
//  Copyright © 2016年 JW. All rights reserved.
//

/*
 AccBrightnessFilter: Adjusts the brightness of the image
 - brightness: The adjusted brightness (-1.0 ~ 1.0, with 0.0 as the default)
*/
class AccBrightnessFilter: AccImageFilter {
    var brightness:Float?
    override init(){
        super.init()
        self.name = "Brightness"
    }
    override func applyFilter() {
        addCommandWithFactor([brightness,0.8])
    }
}
