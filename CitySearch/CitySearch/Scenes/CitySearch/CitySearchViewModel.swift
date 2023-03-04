
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
                return self.itemWithOffset(offset: index.row)
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
    
    // Find item with Offset
    func itemWithOffset(offset: Int) -> CitySearchItemViewModel {
        return items[resultsIndex.first + offset]
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
        let startDate = Date()
        let indexFirst = findFirstIndex(search: search)
        let indexLast = findLastIndex(search: search)
        
        resultsIndex = (first: indexFirst, last: indexLast)
        debugPrint("Query Text: \(search) - time: \(Date().timeIntervalSince(startDate))")
        return items
    }
    
    private func findFirstIndex(search: String) -> Int {
        var start = 0
        var end = items.count - 1
        let search = search.lowercased()
        
        while start < end {
            let mid = (start + end) / 2
            
            if items[mid].searchValue < search {
                start = mid + 1
            } else {
                end = mid
            }
        }
        
        if items[start].searchValue.hasPrefix(search) {
            return start
        } else {
            return end + 1
        }
    }
    
    private func findLastIndex(search: String) -> Int {
        var start = 0
        var end = itemsReversed.count - 1
        let search = search.lowercased()
        
        while start < end {
            let mid = (start + end) / 2
            
            if itemsReversed[mid].searchValue > search {
                start = mid + 1
            } else {
                end = mid
            }
        }
        
        if itemsReversed[start].searchValue.hasPrefix(search) {
            return items.count - 1 - start
        } else {
            return items.count - 1 - end - 1
        }
    }
}
