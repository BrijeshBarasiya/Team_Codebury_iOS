//
//  DashboardCoordinator.swift
//  SimFocus
//
//  Created by Jay Shah on 02/04/22.
//

import UIKit
import SSCustomTabbar

class DashboardCoordinator: Coordinator {
    
    var navController: UINavigationController
    
    
    init(_ navigationController: UINavigationController) {
        navController = navigationController
    }
    
    func start() {
        if let firstVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateInitialViewController() as? SSCustomTabBarViewController {
            navController.pushViewController(firstVC, animated: true)
            }
        
    }
    
}


