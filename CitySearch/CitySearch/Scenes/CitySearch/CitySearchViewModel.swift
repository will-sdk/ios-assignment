
import Foundation
import RxSwift
import RxCocoa
import Domain

final class CitySearchViewModel {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let cities: Driver<[CitySearchItemViewModel]>
        let selectedCity: Driver<Cities>
    }
    
    private let navigator: CitySearchNavigator
    private let usecase: ListOfCitiesUseCase
    
    init(navigator: CitySearchNavigator, usecase: ListOfCitiesUseCase) {
        self.navigator = navigator
        self.usecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let cities = input.trigger.flatMapLatest {
            return self.usecase.listOfCities()
                .asDriverOnErrorJustComplete()
                .map { $0.map { CitySearchItemViewModel(with: $0) } }
        }
        
        let selectedCity = input.selection
            .withLatestFrom(cities) { (index, cities) -> Cities in
                return cities[index.row].cities
            }
            .do(onNext: navigator.toMapView)
        
        return Output(cities: cities,
                      selectedCity: selectedCity)
        }
}
