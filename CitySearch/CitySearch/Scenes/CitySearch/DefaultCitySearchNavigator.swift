
import UIKit
import Domain

protocol CitySearchNavigator {
    func toMapView(_ cities: Cities)
}

class DefaultCitySearchNavigator: CitySearchNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(storyBoard: UIStoryboard, navigationController: UINavigationController, services: UseCaseProvider) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
        self.services = services
    }
    
    func toCitySearch() {
        let vc = storyBoard.instantiateViewController(ofType: CitySearchViewController.self)
        vc.viewModel = CitySearchViewModel(navigator: self, usecase: services.makeListOfCitiesUseCase())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toMapView(_ cities: Cities) {
        
    }
}
