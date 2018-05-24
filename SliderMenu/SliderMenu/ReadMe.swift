//
//  ReadMe.swift
//  SliderMenu
//
//  Created by Mathews on 18/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

/*
 
 1. The ContainerView controller class invokes the slider menu and handles all the
    related animations.
 
 2. Make the singleton Object of ContainerViewController as the rootViewController
    of the Key Window to start with the slider Menu.
    Check the
    func loadRootViewController();
    method in AppDelegate to find how ContainerViewController is set as root.
 
 3. Use the RootViewController to push your view controllers on top of it.
    Check the
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath);
    method in LeftSliderViewController to find how menu selection is routed to RootViewController class to
    push a new screen atop.
 
 4. Extend all the ViewControllers which should display the Slider Menu from Base
    ViewController which inturn is inherited from UIViewController.
 
 5. Extend all the TableViewControllers which should display the Slider Menu from
    BaseTableViewController which inturn is inherited from UITableViewControllers.
 
 6. Extend all the TabBarControllers which should display the Slider Menu from
    BaseTabBarControllers which inturn is inherited from UITabBarController.
 
 8. Customize the SlideMenu from the SliderMenuConstants.swift
 
 */
