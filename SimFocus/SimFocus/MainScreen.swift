import UIKit

class MainScreen: UIViewController, Storyboarded {

    var navCoordinator: MainScreenCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebServices.getLogin()
    }


}

