
import Foundation
import RxSwift
import RxCocoa
import Domain
import UIKit

final class CitySearchViewModel {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
        let searchQuery = BehaviorRelay<String>(value: "")
    }
    struct Output {
        let cities: Driver<[CitySearchItemViewModel]>
        let selectedCity: Driver<CitySearchItemViewModel>
    }
    
    private let navigator: CitySearchNavigator
    private let usecase: ListOfCitiesUseCase
    
    var items = [CitySearchItemViewModel]()
    private var itemsReversed = [CitySearchItemViewModel]()
    var resultsIndex: (first: Int, last: Int) = (first: 0, last: 0)
    
    init(navigator: CitySearchNavigator, usecase: ListOfCitiesUseCase) {
        self.navigator = navigator
        self.usecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let allCities = input.trigger.flatMapLatest {
            return self.usecase.listOfCities()
                .asDriverOnErrorJustComplete()
                .map { $0.map { CitySearchItemViewModel(with: $0) } }
                .do {
                    self.setupData(cities: $0)
                }
        }
        
        let searchQuery = input.searchQuery
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
        
        let filteredCities = Driver.combineLatest(allCities, searchQuery)
            .map { cities, query -> [CitySearchItemViewModel] in
                return self.filter(search: query)
            }
        
        let selectedCity = input.selection
            .withLatestFrom(filteredCities) { (index, cities) -> CitySearchItemViewModel in
                return cities[index.row]
            }
            .do(onNext: navigator.toMapView)
                
        return Output(cities: filteredCities,
                    selectedCity: selectedCity)
    }
    
    // Sets the value for all searchValue in the cities
    private func setupData(cities: [CitySearchItemViewModel]) {
        items = cities
        parseSearchValues()
        sortItems()
        resultsIndex = (first: 0, last: items.count - 1)
    }
    
    private func parseSearchValues() {
        for index in 0..<items.count {
            items[index].searchValue = items[index].cityAndCountry.lowercased()
        }
    }
    
    private func sortItems() {
        items = items.sorted {
            $0.searchValue < $1.searchValue
        }
        itemsReversed = items.reversed()
    }
    
    // Filter Search Data return Array CitySearchItemViewModel
    private func filter(search: String) -> [CitySearchItemViewModel] {
        if search.isEmpty {
            // If search is empty, all items are visible
            resultsIndex = (first: 0, last: items.count - 1)
            return items
        }
        else {
            return findRange(search: search)
        }
    }
    
    private func findRange(search: String) -> [CitySearchItemViewModel] {
        let startIndex = findFirstIndex(search: search)
        guard startIndex < items.count else {
            // No matches found
            resultsIndex = (first: 0, last: 0)
            return []
        }
        
        let endIndex = findLastIndex(search: search)
        let range = startIndex...endIndex
        resultsIndex = (first: startIndex, last: endIndex)
        return Array(items[range])
    }

    private func findFirstIndex(search: String) -> Int {
        var low = 0
        var high = items.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            let item = items[mid]
            
            if item.cityAndCountry.lowercased().hasPrefix(search.lowercased()) {
                if mid == 0 || !items[mid-1].cityAndCountry.lowercased().hasPrefix(search.lowercased()) {
                    return mid
                } else {
                    high = mid - 1
                }
            } else if item.cityAndCountry.lowercased() < search.lowercased() {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        return items.count
    }

    private func findLastIndex(search: String) -> Int {
        var low = 0
        var high = items.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            let item = items[mid]
            
            if item.cityAndCountry.lowercased().hasPrefix(search.lowercased()) {
                if mid == items.count - 1 || !items[mid+1].cityAndCountry.lowercased().hasPrefix(search.lowercased()) {
                    return mid
                } else {
                    low = mid + 1
                }
            } else if item.cityAndCountry.lowercased() < search.lowercased() {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        return items.count
    }
}
