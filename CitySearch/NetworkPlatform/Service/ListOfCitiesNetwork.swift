
import Domain
import RxSwift

public final class ListOfCitiesNetwork {
    private let network: NetworkFromJsonFile<Cities>
    
    init(network: NetworkFromJsonFile<Cities>) {
        self.network = network
    }
    
    public func fetchListOfCities() -> Observable<[Cities]> {
        return network.getListOfCitiesService()
    }
}
