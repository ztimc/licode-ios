//
//  ViewController.swift
//  LicodeExample
//
//  Created by ztimc on 2018/9/20.
//  Copyright © 2018年 ztimc. All rights reserved.
//

import UIKit
import licode

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let channel = SignalingChannel()
        channel.connectByToken(encodedToken: "eyJ0b2tlbklkIjoiNWJhMzk1MzEwZjg0OTA1OTAxMWJmZWQ1IiwiaG9zdCI6IndlYnJ0Yy5tdWd1b3ZyLmNuOjgwODAiLCJzZWN1cmUiOnRydWUsInNpZ25hdHVyZSI6Ill6WTNNemRqWmpjd01HWTJaVEU1T1RJMFpUVTBaalZoTm1JNVlURTVPREEzWWpOaE5XUTFNQT09In0=")
    }
    
    


}

