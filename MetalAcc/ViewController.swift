//
//  ViewController.swift
//  MetalAcc
//
//  Created by 王佳玮 on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let inimage = UIImage(named: "AnimalImage")!
        
        // Create ImageView and add animated image
        let imageview = UIImageView()
        imageview.frame = CGRect(x: 0.0, y: 40 , width: 250, height: 200)
        
        let accimage = AccImage()
        accimage.AddImage(inimage)
        

        let filter = AccBrightnessFilter()
        filter.brightness = 0.95
         
        accimage.AddFilter(filter)
        //let after = image
        let outimage = accimage.Processing()
        imageview.image = outimage
 
        self.view.addSubview(imageview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

