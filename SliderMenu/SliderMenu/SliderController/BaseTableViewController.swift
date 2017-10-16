//
//  BaseTableViewController.swift
//  Marinfo
//
//  Created by Mathews on 30/05/17.
//  Copyright © 2017 maritus. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSliderOptions()
    }

    
    func configureSliderOptions() {
        switch  sliderMenuType {
        case .leftOnly:
            self.addLeftBarButton()
            break
        case .rightOnly:
            self.addRightBarButton()
            break
        case .leftAndRight:
            self.addLeftBarButton()
            self.addRightBarButton()
            break
        }
    }
    
    func addLeftBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(named: leftMenuImage), for: .normal)
        button.addTarget(self, action: #selector(self.leftMenuButtonAction(sender:)), for: .touchUpInside)
        
        let barbutton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barbutton
    }
    
    func addRightBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(named: rightMenuImage), for: .normal)
        button.addTarget(self, action: #selector(self.rightMenuButtonAction(sender:)), for: .touchUpInside)
        
        let barbutton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barbutton
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


// MARK: - Slide Menu Buttons action targets
extension BaseTableViewController {
    
    func leftMenuButtonAction (sender: UIButton) {
        ContainerViewController.sharedInstance.toggleLeftSlider()
    }
    
    func rightMenuButtonAction (sender: UIButton) {
        ContainerViewController.sharedInstance.toggleRightSlider()
    }
}
