
import UIKit

class DefaultCitySearchNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    
    init(storyBoard: UIStoryboard, navigationController: UINavigationController) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
    }
    
    func toCitySearch() {
        let vc = storyBoard.instantiateViewController(ofType: CitySearchViewController.self)
        navigationController.pushViewController(vc, animated: true)
    }
}
