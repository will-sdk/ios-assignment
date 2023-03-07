
import Foundation

public struct Cities: Codable {
    public let country: String
    public let name: String
    public let coord: Location

    public init(country: String,
                name: String,
                coord: Location) {
        self.country = country
        self.name = name
        self.coord = coord
    }

    private enum CodingKeys: String, CodingKey {
        case country
        case name
        case coord
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(country, forKey: .country)
        try container.encode(name, forKey: .name)
        try container.encode(coord, forKey: .coord)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        country = try container.decode(String.self, forKey: .country)
        name = try container.decode(String.self, forKey: .name)
        coord = try container.decode(Location.self, forKey: .coord)
    }
}


extension Cities: Equatable {
    public static func == (lhs: Cities, rhs: Cities) -> Bool {
            return lhs.country == rhs.country &&
                lhs.name == rhs.name
    }
}

public struct Location: Codable {
    public let lon: Double
    public let lat: Double
    
    public init(lon: Double,
                lat: Double) {
        self.lon = lon
        self.lat = lat
    }
    
    private enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lon, forKey: .lon)
        try container.encode(lat, forKey: .lat)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
    }
}

extension Location: Equatable {
    public static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.lon == rhs.lon &&
                lhs.lat == rhs.lat
    }
}
