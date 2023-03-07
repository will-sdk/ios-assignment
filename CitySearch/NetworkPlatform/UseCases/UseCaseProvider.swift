
import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    
    private let networkProvider: NetworkProvider
    
    public init() {
        networkProvider = NetworkProvider()
    }
    
    public func makeListOfCitiesUseCase() -> Domain.ListOfCitiesUseCase {
        return ListOfCitiesUseCase(network: networkProvider.makeListOfCitiesNetwork())
    }
}
