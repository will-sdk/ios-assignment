
import RxSwift

public protocol ListOfCitiesUseCase {
    func listOfCities() -> Observable<[Cities]>
}
