//
//  BaseViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSliderOptions()
        self.registerForPanGestures()
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 13))
        button.setBackgroundImage(UIImage(named: leftMenuImage), for: .normal)
        button.addTarget(self, action: #selector(self.leftMenuButtonAction), for: .touchUpInside)
        
        let barbutton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barbutton
    }
    
    func addRightBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 13))
        button.setBackgroundImage(UIImage(named: rightMenuImage), for: .normal)
        button.addTarget(self, action: #selector(self.rightMenuButtonAction), for: .touchUpInside)
        
        let barbutton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barbutton
    }

    /// registers for pan gesture recognition to toggle the slide menu
    func registerForPanGestures() {
        let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        leftPan.edges = .left
        self.view.addGestureRecognizer(leftPan)
        
        let rightPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        rightPan.edges = .right
        self.view.addGestureRecognizer(rightPan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension BaseViewController {
    
    func leftMenuButtonAction () {
        ContainerViewController.sharedInstance.toggleLeftSlider()
    }
    
    func rightMenuButtonAction () {
        ContainerViewController.sharedInstance.toggleRightSlider()
    }
    
    func handlePan(sender: UIScreenEdgePanGestureRecognizer) {
        ContainerViewController.sharedInstance.handlePanGesture(recognizer: sender)
    }
}
