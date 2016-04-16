//
//  HappinessViewController.swift
//  Happiness
//
//  Created by 淡蓝色的泪 on 4/4/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController
{
    var happiness: Int = 50 {   //0 = very sad, 100 = ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    func updateUI()
    {
        
    }
    
}
