
import Domain
import RxSwift
import RxCocoa

final class MapViewModel {
    private let cities: Cities
    private let navigator: MapNavigator
    
    init(cities: Cities, navigator: MapNavigator) {
        self.cities = cities
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let cities = input.trigger
            .map { self.cities }
        
        return Output(cities: cities)
    }
    
}

extension MapViewModel {
    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let cities: Driver<Cities>
    }
}
