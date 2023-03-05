
import Foundation

class CitySearchNavigatorMock: CitySearchNavigator {
    
    var toMapViewCalled = false
    var selectedCity: CitySearchItemViewModel?
    
    func toMapView(_ citySearchItem: CitySearchItemViewModel)  {
        toMapViewCalled = true
        selectedCity = citySearchItem
    }
}
