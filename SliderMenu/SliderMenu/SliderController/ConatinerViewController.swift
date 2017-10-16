//
//  ConatinerViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit


enum SliderMenuType {
    case leftOnly //add only the left slider
    case rightOnly //add only the right slider
    case leftAndRight //add both left and right sliders
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
    var overlayView: UIView?

    
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
        self.addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        super.viewWillDisappear(animated)
    }
    
    
    func handleOrientationChange() {
        DispatchQueue.main.async{
            if self.sliderMenuCurrentState == .leftOpen {
                self.rootNavController?.view.frame.origin.x = self.rootViewController!.view.frame.size.width - CGFloat(centerViewExpandedOffset)
            }
        }
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
    
    func addGestureRecognizers() {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(recognizer:)))
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        rootNavController?.view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(recognizer:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        rootNavController?.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// Mark - LeftSliderMenu methods
extension ContainerViewController {
    
    
    /// Method creates the left slider instance
    func addLeftSlideMenu() {
        if self.leftSliderController == nil {
            leftSliderController = UIStoryboard.leftSliderViewController()
            self.addLeftSlideMenuAsChild()
        }
    }
    
    
    /// Method determines the direction to animate the slider
    ///
    /// - Parameter expandSlider: boolean value which determines whether to expand or collapse the left slider
    func animateLeftSlider(expandSlider: Bool) {
        if expandSlider {
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
    
    /// Method adds the left slider to the containerViewController
    func addLeftSlideMenuAsChild() {
        self.view.insertSubview((self.leftSliderController?.view)!, at: 0)
        self.addChildViewController(leftSliderController!)
        self.leftSliderController?.didMove(toParentViewController: self)
    }

}

//Mark - RightSliderMenu methods
extension ContainerViewController {
    
    /// Method creates the right slider instance
    func addRightSlideMenu() {
        if self.rightSliderController == nil {
            self.rightSliderController = UIStoryboard.rightSliderViewController()
            self.addRightSlideMenuAsChild()
        }
    }
    
    /// Method determines the direction to animate the slider
    ///
    /// - Parameter expandSlider: boolean value which determines whether to expand or collapse the right slider
    func animateRightSlider(expandSlider: Bool) {
        if expandSlider {
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
    
    /// Method adds the right slider to the containerViewController
    func addRightSlideMenuAsChild() {
        self.view.insertSubview((self.rightSliderController?.view)!, at: 0)
        self.addChildViewController(self.rightSliderController!)
        self.rightSliderController?.didMove(toParentViewController: self)
    }
}


//Mark - Animate Center view controller
extension ContainerViewController {
    
    /// Method animates the center view to reveal or close the slider menu
    ///
    /// - Parameters:
    ///   - offset: offset on x-axis the center view is to be animated to
    ///   - handler: completion handler is invoked once the animation is committed
    func animateCenterView(offset: CGFloat, handler: @escaping (Bool)->Void) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.rootNavController?.view.frame.origin.x = offset
        }) { (completed) in
            handler(completed)
        }
    }
    
    
    /// Method adds or remove shadow to center view
    ///
    /// - Parameter showShadow: boolean flag determines whether to add/remove shadow
    func setShadowToCentreView(showShadow: Bool) {
        if showShadow {
            self.rootNavController?.view.layer.masksToBounds = false
            self.rootNavController?.view.layer.shadowColor = UIColor.darkGray.cgColor
            self.rootNavController?.view.layer.shadowOpacity = 0.8
            self.addOverlayOnCenterView()
        }
        else {
            self.rootViewController?.view.layer.shadowOpacity = 0.0
            self.removeOverlayFromCenterView()
        }
    }
    
    /// Method adds an overlay view to the center view
    /// Overlay differentiates the slider from center view and captures touch to center view elements
    /// Method is invoked when slider is expanded
    func addOverlayOnCenterView() {
        if self.overlayView == nil {
            self.overlayView = UIView()
        }
        self.rootViewController?.view.addSubview(self.overlayView!)
        self.rootViewController?.view.backgroundColor = UIColor.white
        self.overlayView?.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self.overlayView!, attribute: .leading, relatedBy: .equal, toItem: self.rootViewController?.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.overlayView!, attribute: .top, relatedBy: .equal, toItem: self.rootViewController?.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.overlayView!, attribute: .trailing, relatedBy: .equal, toItem: self.rootViewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.overlayView!, attribute: .bottom, relatedBy: .equal, toItem: self.rootViewController?.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.rootViewController?.view.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
        self.rootViewController?.view.bringSubview(toFront: self.overlayView!)
        self.overlayView?.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
    }
    
    /// Method removes the overlay view added to the center view
    /// Method is invoked when slider is collapsed
    func removeOverlayFromCenterView() {
        self.overlayView?.removeFromSuperview()
        self.overlayView = nil
    }
}


// MARK: - GestureRecognizerDelegate
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    
    /// Action target for pan gesture recognizer
    /// Handle gesture if project has subsribed for that particular slider instance (left/ right)
    ///
    /// - Parameter recognizer: gesture recognizer instance which invoked the method
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        recognizer.cancelsTouchesInView = false
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        switch(recognizer.state) {
        case .began:
            recognizer.cancelsTouchesInView = true
            
            //check the direction of pan gesture, whether the slider is already open and whether the slidercontroller has registered for that particluar slider menu (left/right)
            if (gestureIsDraggingFromLeftToRight && !(self.sliderMenuCurrentState == .rightOpen)) && (sliderMenuType == .leftOnly || sliderMenuType == .leftAndRight) {
                
                //add the left slider menu and wait for the centerview to animate itself
                self.addLeftSlideMenu()
                self.sliderMenuCurrentState = .leftOpen
                
            } else if (!gestureIsDraggingFromLeftToRight && !(self.sliderMenuCurrentState == .leftOpen)) && (sliderMenuType == .rightOnly || sliderMenuType == .leftAndRight){
                
                //add the right slider menu and wait for the centerview to animate itself
                self.addRightSlideMenu()
                self.sliderMenuCurrentState = .rightOpen
                
            }
        case .changed:
            if self.sliderMenuCurrentState != .bothCollapsed {
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            
            //animate the slider in either direction if the screen has swept half way accross
            //The animateLeftSlider/animateRightSlider methods determine whether to open or close the slider depending on the enum variable value
            if (self.leftSliderController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                self.animateLeftSlider(expandSlider: hasMovedGreaterThanHalfway)
            }
                
            else if (self.rightSliderController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                self.animateRightSlider(expandSlider: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
    
    
    /// Action target for tap gesture recognizer
    ///
    /// - Parameter recognizer: gesture recognizer instance which invoked the method
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        
        if (self.sliderMenuCurrentState == .leftOpen)
        {
            self.toggleLeftSlider()
        }
        else if (self.sliderMenuCurrentState == .rightOpen)
        {
            self.toggleRightSlider()
        }
        recognizer.cancelsTouchesInView = false
    }
    
}


// MARK: - SliderMenuDelegate
extension ContainerViewController: SliderMenuDelegate {
    
    
    /// Open/Close left-slider menu - invoked by menu button or tap gesture
    func toggleLeftSlider() {
        if self.leftSliderController == nil && (sliderMenuType == .leftOnly || sliderMenuType == .leftAndRight) {
            //open left slider if left slider is not already open and left slider is configured in SliderConfiguration file
            self.addLeftSlideMenu()
            self.sliderMenuCurrentState = .leftOpen
            self.animateLeftSlider(expandSlider: true)
        }
        else {
            self.animateLeftSlider(expandSlider: false)
        }
    }
    
    /// Open/Close right-slider menu - invoked by menu button or tap gesture
    func toggleRightSlider() {
        if self.rightSliderController == nil && (sliderMenuType == .rightOnly || sliderMenuType == .leftAndRight)  {
            //open right slider if right slider is not already open and right slider is configured in SliderConfiguration file
            self.addRightSlideMenu()
            self.sliderMenuCurrentState = .rightOpen
            self.animateRightSlider(expandSlider: true)
        }
        else {
            self.animateRightSlider(expandSlider: false)
        }
    }
}


// MARK: - UIStoryBoardExtension
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
