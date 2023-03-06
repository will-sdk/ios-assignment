import XCTest
import RxSwift
import RxCocoa
import RxTest
import Domain

@testable import CitySearch

class CitySearchViewModelTests: XCTestCase {

    var sut: CitySearchViewModel!
    var usecase: ListOfCitiesUseCaseMock!
    var navigator: CitySearchNavigatorMock!
    var input: CitySearchViewModel.Input!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        usecase = ListOfCitiesUseCaseMock()
        navigator = CitySearchNavigatorMock()
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
        let cities = [Cities.stub(),
                      Cities.stub(),
                      Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
                      Cities(country: "US", name: "Arizona", coord: Location.stub())]
        usecase.listOfCitiesResult = .just(cities)
        let expectedOutput = [
            CitySearchItemViewModel(with: cities[0]),
            CitySearchItemViewModel(with: cities[1]),
            CitySearchItemViewModel(with: cities[2]),
            CitySearchItemViewModel(with: cities[3])
        ]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        
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
        
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?.first?.cityAndCountry, expectedOutput.first?.cityAndCountry)
    }

    func test_transform_with_non_empty_query_returns_matching_cities() {
        // Given
        let cities = [Cities.stub(),
                      Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
                      Cities(country: "US", name: "Arizona", coord: Location.stub())]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [CitySearchItemViewModel(with: cities[1])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("Alb")
        
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

    func test_transform_with_selection_emits_selected_city_index_1() {
        // Given
        let cities = [Cities.stub(),
                      Cities(country: "US", name: "Arizona", coord: Location.stub()),
                      Cities(country: "AU", name: "Sydney", coord: Location.stub())
                      ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = CitySearchItemViewModel(with: cities[1])
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: scheduler.createColdObservable([.next(10, ())]).asDriver(onErrorJustReturn: ()),
                          selection: scheduler.createColdObservable([.next(20, IndexPath(row: 1, section: 0))]).asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0)))
        let output = sut.transform(input: input)
        
        // When
        let selectedCityExpectation = XCTestExpectation(description: "Selected city emitted")
        var emittedCity: CitySearchItemViewModel?
        let disposable = output.selectedCity
            .drive(onNext: { city in
                emittedCity = city
                selectedCityExpectation.fulfill()
            })
        scheduler.start()

        // Then
        wait(for: [selectedCityExpectation], timeout: 1.0)
        disposable.dispose()
        XCTAssertEqual(emittedCity?.cityName, expectedOutput.cityName)
        XCTAssertEqual(emittedCity!.cityAndCountry, "Arizona, US")
        XCTAssertTrue(navigator.toMapViewCalled)
    }
    
    func test_transform_with_prefix_a_returns_cities_with_prefix_a() {
        // Given
        let cities = [Cities(country: "US", name: "Alabama", coord: Location.stub()),
                      Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
                      Cities(country: "US", name: "Anaheim", coord: Location.stub()),
                      Cities(country: "US", name: "Arizona", coord: Location.stub()),
                      Cities(country: "AU", name: "Sydney", coord: Location.stub())
                      ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [
            CitySearchItemViewModel(with: cities[0]),
            CitySearchItemViewModel(with: cities[1]),
            CitySearchItemViewModel(with: cities[2]),
            CitySearchItemViewModel(with: cities[3])
        ]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: scheduler.createColdObservable([.next(10, ())]).asDriver(onErrorJustReturn: ()),
                              selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("A")
        
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
        XCTAssertEqual(result?.count, 4)
        XCTAssertEqual(result?.map { $0.cityAndCountry }, expectedOutput.map { $0.cityAndCountry })
        XCTAssertEqual(result?.first?.cityAndCountry, expectedOutput.first?.cityAndCountry)
        XCTAssertEqual(result?.last?.cityAndCountry, expectedOutput.last?.cityAndCountry)
        XCTAssertEqual(result?[3].cityAndCountry, expectedOutput[3].cityAndCountry)
        XCTAssertFalse(result!.contains(where: { $0.cityName == "Sydney" }))
    }
    
    func test_transform_with_prefix_s_returns_sydney() {
        // Given
        let cities = [
            Cities(country: "US", name: "Alabama", coord: Location.stub()),
            Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
            Cities(country: "US", name: "Anaheim", coord: Location.stub()),
            Cities(country: "US", name: "Arizona", coord: Location.stub()),
            Cities(country: "AU", name: "Sydney", coord: Location.stub())
        ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [CitySearchItemViewModel(with: cities[4])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("s")
        
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
    
    func test_transform_with_prefix_Al_returns_Alabama_and_Albuquerque() {
        // Given
        let cities = [
            Cities(country: "US", name: "Alabama", coord: Location.stub()),
            Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
            Cities(country: "US", name: "Anaheim", coord: Location.stub()),
            Cities(country: "US", name: "Arizona", coord: Location.stub()),
            Cities(country: "AU", name: "Sydney", coord: Location.stub())
        ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [CitySearchItemViewModel(with: cities[0]), CitySearchItemViewModel(with: cities[1])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("Al")
        
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
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.map { $0.cityAndCountry }, expectedOutput.map { $0.cityAndCountry })
    }

    func test_transform_with_prefix_Alb_returns_Albuquerque() {
        // Given
        let cities = [
            Cities(country: "US", name: "Alabama", coord: Location.stub()),
            Cities(country: "US", name: "Albuquerque", coord: Location.stub()),
            Cities(country: "US", name: "Anaheim", coord: Location.stub()),
            Cities(country: "US", name: "Arizona", coord: Location.stub()),
            Cities(country: "AU", name: "Sydney", coord: Location.stub())
        ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [CitySearchItemViewModel(with: cities[1])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("Alb")
        
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
    
    func test_transform_with_empty_cities() {
        // Given
        usecase.listOfCitiesResult = .just([])
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        
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
        
        XCTAssertEqual(result?.count, 0)
    }
    
    func test_transform_with_empty_data_when_search_not_match() {
        // Given
        let cities = [
            Cities(country: "AU", name: "Sydney", coord: Location.stub())
        ]
        usecase.listOfCitiesResult = .just(cities)
        sut.items = cities.map { CitySearchItemViewModel(with: $0) }
        let expectedOutput = [CitySearchItemViewModel(with: cities[0])]
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        input.searchQuery.accept("Alccc")
        
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
        XCTAssertEqual(result?.count, 0)
        XCTAssertTrue(result?.isEmpty ?? false)
        XCTAssertNotEqual(result?.map { $0.cityAndCountry }, expectedOutput.map { $0.cityAndCountry })
    }
    
    func test_transform_with_empty_data_when_city_is_nil() {
        // Given
        let cities: [Cities?] = [nil]
        usecase.listOfCitiesResult = .just(cities.compactMap { $0 })
        sut.items = cities.compactMap { $0 }.map { CitySearchItemViewModel(with: $0) }
     
        let scheduler = TestScheduler(initialClock: 0)
        let input = CitySearchViewModel.Input(trigger: Driver.just(()), selection: Driver.just(IndexPath(row: 0, section: 0)))
        
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
        XCTAssertEqual(result?.count, 0)
    }



}
