import XCTest
import RxSwift
import RxCocoa
import Domain

@testable import CitySearch // replace with your app name

class CitySearchViewModelTests: XCTestCase {

    var sut: CitySearchViewModel!
    var usecase: MockListOfCitiesUseCase!
    var navigator: MockCitySearchNavigator!
    var input: CitySearchViewModel.Input!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        usecase = MockListOfCitiesUseCase()
        navigator = MockCitySearchNavigator()
        sut = CitySearchViewModel(navigator: navigator, usecase: usecase)
        input = CitySearchViewModel.Input(trigger: Driver.just(()),
                                          selection: Driver.just(IndexPath(row: 0, section: 0)))
    }

    override func tearDownWithError() throws {
        navigator = nil
        usecase = nil
        input = nil
        sut = nil
        try super.tearDownWithError()
    }
    func test_transform_with_empty_query_returns_all_cities() {
        // Given
        let mockCity = Cities(country: "USA", name: "New York", coord: Location(lon: 0.0, lat: 0.0))
        let cities = [Cities.stub(), Cities.stub()]
        usecase.listOfCitiesResult = .just(cities)
        let expectedOutput = [        CitySearchItemViewModel(with: cities[0]),
            CitySearchItemViewModel(with: cities[1])
        ]
        let scheduler = TestScheduler(initialClock: 0)
        let input = Input(searchQuery: scheduler.createColdObservable([.next(10, "")]).asDriver(onErrorJustReturn: ""), itemSelection: scheduler.createColdObservable([.next(20, expectedOutput[0])]).asDriver(onErrorJustReturn: .empty()))

        // When
        let output = sut.transform(input: input)

        // Then
        var result: [CitySearchItemViewModel]?
        output.cities
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.map { $0.cityAndCountry }, expectedOutput.map { $0.cityAndCountry })
    }

    func test_transform_with_non_empty_query_returns_matching_cities() {
        // Given
        let cities = [Cities.stub(), Cities.stub()]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        sut.parseSearchValues()
        let expectedOutput = [CitySearchItemViewModel(with: cities[0])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = Input(searchQuery: scheduler.createColdObservable([.next(10, "Lon")]).asDriver(onErrorJustReturn: ""), itemSelection: scheduler.createColdObservable([.next(20, expectedOutput[0])]).asDriver(onErrorJustReturn: .empty()))

        // When
        let output = sut.transform(input: input)
        var result: [CitySearchItemViewModel]?
        output.cities
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.map { $0.cityAndCountry }, expectedOutput.map { $0.cityAndCountry })
    }

    

    func test_transform_with_selection_emits_selected_city() {
        // Given
        let cities = [City(name: "London", country: "UK"), City(name: "New York", country: "USA")]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = CitySearchItemViewModel(with: cities[0])

        // When
        let output = sut.transform(input: input)
        input.selection.accept(IndexPath(row: 0, section: 0))

        // Then
        XCTAssertEqual(try output.selectedCity.toBlocking().first()?.cityAndCountry,
                       expectedOutput.cityAndCountry)
        XCTAssertTrue(navigator.toMapViewCalled)
    }
}

class MockListOfCitiesUseCase: Domain.ListOfCitiesUseCase {

    var listOfCitiesResult: Observable<[Cities]> = .never()

    func listOfCities() -> RxSwift.Observable<[Domain.Cities]> {
        return listOfCitiesResult
    }
}

class MockCitySearchNavigator: CitySearchNavigator {
    
    var toMapViewCalled = false
    var selectedCity: CitySearchItemViewModel?
    
    func toMapView(_ city: CitySearchItemViewModel) {
        toMapViewCalled = true
        selectedCity = city
    }
}
