
import UIKit

protocol MapNavigator {
    func toPosts()
}

final class DefaultMapNavigator: MapNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toPosts() {
        navigationController.popViewController(animated: true)
    }
}
