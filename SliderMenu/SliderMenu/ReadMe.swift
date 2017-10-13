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
    of the AppDelegate Window to start with the slider Menu.
 
 3. Use the RootViewController as your home screen viewcontroller or
    replace the RootViewController with your HomeSceen ViewController and extend it
    from BaseViewController which inturn is inherited from UIViewController. When
    replacing the RootViewController with your HomeScreen ViewController class,
    replace all calls to the RootViewController class  in ContainerViewController
    with corresponding custom class name.
 
 4. Extend all the ViewControllers which should display the Slider Menu from Base
    ViewController which inturn is inherited from UIViewController.
 5. Extend all the TableViewControllers which should display the Slider Menu from Base
    TableViewController which inturn is inherited from UIViewController.
 
 6. Customize the SlideMenu from the SliderMenuConstants.swift
 
 */
