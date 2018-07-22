//
//  TabBarController.swift
//  Friendster Messenger
//
//  Created by Student 3 on 2/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

class FriendsterTabBar : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsterCollectionController(collectionViewLayout: layout)
        
        // Recent Chat Tab - Navigation Controller
        let recentNavigationController = UINavigationController(rootViewController: friendsController)
        recentNavigationController.tabBarItem.title = "Recent Chat"
        recentNavigationController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [recentNavigationController,
                           createDummyNavController(tabBarTitle: "Groups Chat", tabBarImageName: "groups"),
                           createDummyNavController(tabBarTitle: "People", tabBarImageName: "people"),
                           createDummyNavController(tabBarTitle: "Settings", tabBarImageName: "settings")]
    }
    
    private func createDummyNavController(tabBarTitle: String, tabBarImageName: String) -> UINavigationController {
        let newViewController = UIViewController()
        let newNavController = UINavigationController(rootViewController: newViewController)
        newNavController.tabBarItem.title = tabBarTitle
        newNavController.tabBarItem.image = UIImage(named: tabBarImageName)
    
        return newNavController
    }
    
    
}
