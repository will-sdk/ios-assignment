import XCTest
import RxSwift
import RxCocoa
import RxTest
import Domain

@testable import CitySearch

class MapViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var navigator: MapNavigatorMock!
    var sut: MapViewModel!
    var input: MapViewModel.Input!

    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        navigator = MapNavigatorMock()
        sut = MapViewModel(citySearchItem: CitySearchItemViewModel(with: Cities.stub()), navigator: navigator)
        input = MapViewModel.Input(trigger: Driver.just(()))
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        navigator = nil
        sut = nil
        input = nil
        try super.tearDownWithError()
    }

    func test_transform_with_city_and_country_name() {
        // Given
        let city = Cities(country: "AU", name: "Sydney", coord: Location.stub())
        let citySearchItem = CitySearchItemViewModel(with: city)
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: citySearchItem, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))

        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(result?.cityAndCountry, "Sydney, AU")
    }
    
    func test_transform_with_coordinate() {
        // Given
        let city = Cities(country: "AU", name: "Sydney", coord: Location(lon: 10.12345, lat: 15.12345))
        let citySearchItem = CitySearchItemViewModel(with: city)
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: citySearchItem, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))

        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(result?.latAndlong, "lat: 15.12345, long: 10.12345")
    }
    
    func test_transform_with_city_and_country_name_and_coordinate() {
        // Given
        let city = Cities(country: "US", name: "Alabama", coord: Location(lon: 10.12345, lat: 15.12345))
        let citySearchItem = CitySearchItemViewModel(with: city)
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: citySearchItem, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))

        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(result?.cityAndCountry, "Alabama, US")
        XCTAssertEqual(result?.latAndlong, "lat: 15.12345, long: 10.12345")
    }
    
    func test_transform_with_nil_city() {
        // Given
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: nil, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))
        
        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertNil(result?.cities)
    }
    
    func test_transform_with_nil_city_name() {
        // Given
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: nil, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))
        
        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertTrue(result?.cityName.isEmpty ?? false)
    }
    
    func test_transform_with_nil_country() {
        // Given
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: nil, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.just(()))
        
        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertTrue(result?.country.isEmpty ?? false)
    }
    
    func test_transform_with_empty_trigger() {
        // Given
        let city = Cities(country: "AU", name: "Sydney", coord: Location.stub())
        let citySearchItem = CitySearchItemViewModel(with: city)
        let navigator = MapNavigatorMock()
        let sut = MapViewModel(citySearchItem: citySearchItem, navigator: navigator)
        let input = MapViewModel.Input(trigger: Driver.empty())

        // When
        let output = sut.transform(input: input)
        var result: CitySearchItemViewModel?
        output.citySearchItem
            .drive(onNext: {
                result = $0
            })
            .disposed(by: disposeBag)

        // Then
        XCTAssertNil(result)
    }
}


