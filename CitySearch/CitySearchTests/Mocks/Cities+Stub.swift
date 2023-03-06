import Domain

extension Cities {
    
    static func stub(country: String = "US",
                     name: String = "Alabama",
                     coord: Location = Location.stub()) -> Self {
        Cities(country: country,
               name: name,
               coord: coord)
    }
}

extension Location {
    
    static func stub(lon: Double = 34.283333,
                     lat: Double = 44.549999) -> Self {
        Location(lon: lon, lat: lat)
    }
}
