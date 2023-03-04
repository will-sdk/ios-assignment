
import Domain

struct CitySearchItemViewModel: Decodable {
    let cityName: String
    let country : String
    let lat : Double
    let long : Double
    let cityAndCountry : String
    let latAndlong : String
    
    var searchValue = ""
    
    let cities: Cities
    init (with cities:Cities) {
        self.cities = cities
        self.cityName = cities.name
        self.country = cities.country
        self.lat = cities.coord.lat
        self.long = cities.coord.lon
        self.cityAndCountry = "\(cities.name), \(cities.country)"
        self.latAndlong = "lat: \(cities.coord.lat), long: \(cities.coord.lon)"
    }
}
