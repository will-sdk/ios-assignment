
import Domain

final class CitySearchItemViewModel {
    let name:String
    let country : String
    let lat : Double
    let long : Double
    
    let cities: Cities
    init (with cities:Cities) {
        self.cities = cities
        self.name = cities.name
        self.country = cities.country
        self.lat = cities.coord.lat
        self.long = cities.coord.lon
    }
}
