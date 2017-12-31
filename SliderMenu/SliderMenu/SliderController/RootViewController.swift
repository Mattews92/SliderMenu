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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFirstVC()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension RootViewController: RootViewControllerDelegate {
    
    
    /// Determines selected menu and navigates to selected screen
    ///
    /// - Parameter item: selected menu item
    func didSelectMenu(item: String) {
        switch item {
        case "First VC":
            self.loadFirstVC()
        case "Second VC":
            self.loadSecondVC()
        default:
            break
        }
    }
    
    func loadFirstVC() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func loadSecondVC() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.navigationController?.pushViewController(controller, animated: false)
    }
}
