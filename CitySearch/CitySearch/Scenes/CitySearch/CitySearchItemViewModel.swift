
import Domain

final class CitySearchItemViewModel {
    let cityName: String
    let country : String
    let lat : Double
    let long : Double
    
    let cities: Cities
    init (with cities:Cities) {
        self.cities = cities
        self.cityName = cities.name
        self.country = cities.country
        self.lat = cities.coord.lat
        self.long = cities.coord.lon
    }
}
