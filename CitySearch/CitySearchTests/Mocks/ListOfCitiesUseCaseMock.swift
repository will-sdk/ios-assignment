@testable import CitySearch
import RxSwift
import Domain

class ListOfCitiesUseCaseMock: ListOfCitiesUseCase {
    var listOfCitiesResult: Observable<[Cities]> = Observable.just([])
    func listOfCities() -> Observable<[Cities]> {
        return listOfCitiesResult
    }
}
