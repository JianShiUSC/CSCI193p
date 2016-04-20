//
//  TextViewController.swift
//  Psychologist
//
//  Created by 淡蓝色的泪 on 4/19/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
}
