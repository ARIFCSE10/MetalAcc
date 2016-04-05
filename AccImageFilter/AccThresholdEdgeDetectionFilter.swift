//
//  AccThresholdEdgeDetectionFilter.swift
//  MetalAcc
//
//  Created by 王佳玮 on 16/4/5.
//  Copyright © 2016年 JW. All rights reserved.
//

public class AccThresholdEdgeDetectionFilter:AccImageFilter{
    public var threshold:Float?
    override public init(){
        super.init()
        self.name = "ThresholdEdgeDetection"
        self.threshold = 0.8;
    }
    override public func applyFilter() {
        addCommandWithFactor([threshold])
    }
}