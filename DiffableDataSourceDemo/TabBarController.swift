//
//  TabBarController.swift
//  DiffableDataSourceDemo
//
//  Created by Russell Archer on 24/12/2019.
//  Copyright © 2019 Russell Archer. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self  // Set ourseleves to be the UITabBarControllerDelegate
    }
    
    /// This func is called when a tab is selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
