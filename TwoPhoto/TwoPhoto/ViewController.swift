//
//  ViewController.swift
//  TwoPhoto
//
//  Created by Иван Смолин on 20/01/16.
//  Copyright © 2016 null inc. All rights reserved.
//

import UIKit
import Knapsack

class ViewController: UIViewController, StoryboardIdentifier {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    static func storyboardIdentifier() -> String {
        return "fun!"
    }
}

