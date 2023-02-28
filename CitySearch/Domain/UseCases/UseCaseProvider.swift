
import Foundation

public protocol UseCaseProvider {
    func makeListOfCitiesUseCase() -> ListOfCitiesUseCase
}
