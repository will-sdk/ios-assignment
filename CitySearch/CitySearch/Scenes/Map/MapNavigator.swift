
import UIKit

protocol MapNavigator {
    func toCitySearch()
}

final class DefaultMapNavigator: MapNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toCitySearch() {
        navigationController.popViewController(animated: true)
    }
}
