
import Foundation
import Domain

final class NetworkProvider {
    private let jsonFileName: String
    private let typeFileName: String
    
    public init() {
        self.jsonFileName = "cities"
        self.typeFileName = "json"
    }
    
    public func makeListOfCitiesNetwork() -> ListOfCitiesNetwork {
        let network = NetworkFromJsonFile<Cities>(jsonFileName: jsonFileName, typeFileNam: typeFileName)
        return ListOfCitiesNetwork(network: network)
    }
}
