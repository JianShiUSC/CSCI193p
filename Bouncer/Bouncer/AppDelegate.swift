//
//  AppDelegate.swift
//  Bouncer
//
//  Created by 淡蓝色的泪 on 4/26/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct Motion {
        static let Manager = CMMotionManager()
    }
}

