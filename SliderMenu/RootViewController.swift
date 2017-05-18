//
//  RootViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit


class RootViewController: BaseViewController {
    var rootViewDelegate: SliderMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Root VC"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
