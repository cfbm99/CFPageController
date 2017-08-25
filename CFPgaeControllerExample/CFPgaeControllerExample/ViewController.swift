//
//  ViewController.swift
//  CFPgaeControllerExample
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(255)) / 256.0, green: CGFloat(arc4random_uniform(255)) / 256.0, blue: CGFloat(arc4random_uniform(255)) / 256.0, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

