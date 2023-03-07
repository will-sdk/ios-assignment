
import UIKit
import Domain
import NetworkPlatform

final class Application {
    static let shared = Application()
    private let networkUseCaseProvider: Domain.UseCaseProvider
    
    private init() {
        self.networkUseCaseProvider = NetworkPlatform.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let citySearchNavigationController = UINavigationController()
        let citySearchNavigator = DefaultCitySearchNavigator(
            storyBoard: storyboard,
            navigationController: citySearchNavigationController,
            services: networkUseCaseProvider)
        
        window.rootViewController = citySearchNavigationController
        window.makeKeyAndVisible()
        
        citySearchNavigator.toCitySearch()
    }
    
}
