
import Domain

struct CitySearchItemViewModel: Decodable {
    let cityName: String
    let country : String
    let lat : Double
    let long : Double
    let fullNameOfCityAndCountry : String
    
    var searchValue = ""
    
    let cities: Cities
    init (with cities:Cities) {
        self.cities = cities
        self.cityName = cities.name
        self.country = cities.country
        self.lat = cities.coord.lat
        self.long = cities.coord.lon
        self.fullNameOfCityAndCountry = "\(cities.name), \(cities.country)"
    }
}
