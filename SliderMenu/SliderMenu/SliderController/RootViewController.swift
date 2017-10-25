//
//  RootViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit


protocol RootViewControllerDelegate {
    func didSelectMenu(item: String)
}

class RootViewController: BaseViewController {
    var rootViewDelegate: SliderMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHomeScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension RootViewController: RootViewControllerDelegate {
    
    
    func didSelectMenu(item: String) {
        switch item {
        case "Home":
            self.loadHomeScreen()
        default:
            break
        }
    }
    
    
    func loadHomeScreen() {
    }
}
