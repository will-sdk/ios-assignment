
import Foundation

public struct Cities: Decodable {
    public let country: String
    public let name: String
    public let coord: Location
    
}

public struct Location: Decodable {
    public let lon: Double
    public let lat: Double
}
