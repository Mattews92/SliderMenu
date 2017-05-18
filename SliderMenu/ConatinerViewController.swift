//
//  ConatinerViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit


enum SliderMenuType {
    case leftOnly
    case rightOnly
    case leftAndRight
}

protocol SliderMenuDelegate {
    func toggleLeftSlider()
    func toggleRightSlider()
}

class ContainerViewController: UIViewController {
    
    enum SliderMenuState {
        case leftOpen
        case rightOpen
        case bothCollapsed
    }
    
    var sliderMenuCurrentState: SliderMenuState = .bothCollapsed {
        didSet {
            let shouldSetShadow = (self.sliderMenuCurrentState != .bothCollapsed)
            self.setShadowToCentreView(showShadow: shouldSetShadow)
        }
    }
    var rootViewController: RootViewController?
    var rootNavController: UINavigationController?
    var leftSliderController: LeftSliderViewController?
    var rightSliderController: RightSliderViewController?

    
    class var sharedInstance: ContainerViewController {
        struct Static {
            static let instance: ContainerViewController = ContainerViewController()
        }
        return Static.instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sliderMenuCurrentState = .bothCollapsed
        self.rootViewController = UIStoryboard.rootViewController()
        self.addRootViewController()
    }
    
    
    func addRootViewController() {
        self.rootNavController = UINavigationController(rootViewController: rootViewController!)
        rootViewController?.rootViewDelegate = self
        self.view.addSubview((self.rootNavController?
            .view)!)
        self.view.bringSubview(toFront: (self.rootNavController?.view)!)
        self.addChildViewController(self.rootNavController!)
        self.rootNavController?.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// Mark - LeftSliderMenu methods
extension ContainerViewController {
    
    func addLeftSlideMenu() {
        if self.leftSliderController == nil {
            leftSliderController = UIStoryboard.leftSliderViewController()
            self.addLeftSlideMenuAsChild()
        }
    }
    
    func animateLeftSlider() {
        if self.sliderMenuCurrentState != .leftOpen {
            self.sliderMenuCurrentState = .leftOpen
            let centerViewAnimateOffset = self.rootViewController!.view.frame.size.width - CGFloat(centerViewExpandedOffset)
            self.animateCenterView(offset: centerViewAnimateOffset, handler: { (completed) in
            })
        }
        else {
            self.animateCenterView(offset: 0, handler: { (completed) in
                self.sliderMenuCurrentState = .bothCollapsed
                
                self.leftSliderController?.view.removeFromSuperview()
                self.leftSliderController = nil
            })
        }
    }
    
    func addLeftSlideMenuAsChild() {
        self.view.insertSubview((self.leftSliderController?.view)!, at: 0)
        self.addChildViewController(leftSliderController!)
        self.leftSliderController?.didMove(toParentViewController: self)
    }

}

//Mark - RightSliderMenu methods
extension ContainerViewController {
    
    func addRightSlideMenu() {
        if self.rightSliderController == nil {
            self.rightSliderController = UIStoryboard.rightSliderViewController()
            self.addRightSlideMenuAsChild()
        }
    }
    
    func animateRightSlider() {
        if self.sliderMenuCurrentState != .rightOpen {
            self.sliderMenuCurrentState = .rightOpen
            let centerViewAnimateOffset = -((self.rootViewController?.view.frame.size.width)! - CGFloat(centerViewExpandedOffset))
            self.animateCenterView(offset: centerViewAnimateOffset, handler: { (completed) in
            })
        }
        else {
            self.animateCenterView(offset: 0, handler: { (completed) in
                self.sliderMenuCurrentState = .bothCollapsed
                self.rightSliderController?.view.removeFromSuperview()
                self.rightSliderController = nil
            })
        }
    }
    
    func addRightSlideMenuAsChild() {
        self.view.insertSubview((self.rightSliderController?.view)!, at: 0)
        self.addChildViewController(self.rightSliderController!)
        self.rightSliderController?.didMove(toParentViewController: self)
    }
}


//Mark - Animate Center view controller
extension ContainerViewController {
    
    func animateCenterView(offset: CGFloat, handler: @escaping (Bool)->Void) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.rootNavController?.view.frame.origin.x = offset
        }) { (completed) in
            handler(completed)
        }
    }
    
    func setShadowToCentreView(showShadow: Bool) {
        if showShadow {
            self.rootViewController?.view.layer.shadowOpacity = 0.8
        }
        else {
            self.rootViewController?.view.layer.shadowOpacity = 0.0
        }
    }
}


extension ContainerViewController: SliderMenuDelegate {
    func toggleLeftSlider() {
        let leftSliderExpanded = (self.sliderMenuCurrentState == .leftOpen)
        if !leftSliderExpanded {
            self.addLeftSlideMenu()
        }
        self.animateLeftSlider()
    }
    
    func toggleRightSlider() {
        let rightSliderExpanded = (self.sliderMenuCurrentState == .rightOpen)
        if !rightSliderExpanded {
            self.addRightSlideMenu()
        }
        self.animateRightSlider()
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func leftSliderViewController() -> LeftSliderViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftSliderViewController") as? LeftSliderViewController
    }
    
    class func rightSliderViewController() -> RightSliderViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RightSliderViewController") as? RightSliderViewController
    }
    
    class func rootViewController() -> RootViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
    }
    
}
