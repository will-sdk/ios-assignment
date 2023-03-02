
import Foundation
import RxSwift
import RxCocoa
import Domain

final class CitySearchViewModel {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
        let searchQuery = BehaviorRelay<String>(value: "")
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
        let allCities = input.trigger.flatMapLatest {
            return self.usecase.listOfCities()
                .asDriverOnErrorJustComplete()
                .map { $0.map { CitySearchItemViewModel(with: $0) } }
        }
        
        let searchQuery = input.searchQuery
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
        
        let filteredCities = Driver.combineLatest(allCities, searchQuery)
            .map { cities, query -> [CitySearchItemViewModel] in
                if query.isEmpty {
                    return cities
                } else {
                    return cities.filter { $0.cityName.localizedCaseInsensitiveContains(query) }
                }
        }
        
        let selectedCity = input.selection
            .withLatestFrom(filteredCities) { (index, cities) -> Cities in
                return cities[index.row].cities
            }
            .do(onNext: navigator.toMapView)
                
                return Output(cities: filteredCities,
                              selectedCity: selectedCity)
    }
}
