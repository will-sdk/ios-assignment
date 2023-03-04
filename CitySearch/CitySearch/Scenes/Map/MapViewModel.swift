
import Domain
import RxSwift
import RxCocoa

final class MapViewModel {
    private let citySearchItem: CitySearchItemViewModel
    private let navigator: MapNavigator
    
    init(citySearchItem: CitySearchItemViewModel, navigator: MapNavigator) {
        self.citySearchItem = citySearchItem
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let citySearchItem = input.trigger
            .map { self.citySearchItem }
        
        return Output(citySearchItem: citySearchItem)
    }
    
}

extension MapViewModel {
    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let citySearchItem: Driver<CitySearchItemViewModel>
    }
}
