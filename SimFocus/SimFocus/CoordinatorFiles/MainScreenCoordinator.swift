import UIKit

class MainScreenCoordinator: Coordinator {
    
    var navController: UINavigationController
    
    
    init(_ navigationController: UINavigationController) {
        navController = navigationController
    }
    
    func start() {
        let firstVC = LoginScreen.instantiate(from: .main)
        firstVC.navCoordinator = self
        navController.pushViewController(firstVC, animated: true)
    }
}
