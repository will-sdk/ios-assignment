
import Domain
import RxSwift

final class ListOfCitiesUseCase: Domain.ListOfCitiesUseCase {
    
    private let network: ListOfCitiesNetwork
    
    init(network: ListOfCitiesNetwork) {
        self.network = network
    }
    
    func listOfCities() -> RxSwift.Observable<[Domain.Cities]> {
        let listOfCities = network.fetchListOfCities()
        return listOfCities
    }
}