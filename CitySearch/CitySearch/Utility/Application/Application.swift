
import UIKit

final class Application {
    static let shared = Application()
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let citySearchNavigationController = UINavigationController()
        
        let citySearchNavigator = DefaultCitySearchNavigator(storyBoard: storyboard, navigationController: citySearchNavigationController)
        window.rootViewController = citySearchNavigationController
        citySearchNavigator.toCitySearch()
    }
    
}
