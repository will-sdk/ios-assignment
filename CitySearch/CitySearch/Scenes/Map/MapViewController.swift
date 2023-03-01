

import UIKit
import MapKit
import SnapKit
import Domain
import RxSwift

struct MapViewConstants {
    static let coordinate: Double = 1000
}

class MapViewController: UIViewController {

    var viewModel: MapViewModel!
    
    let disposBag = DisposeBag()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindElements()
    }
    
    private func setupViews() {
        // Add map view to the view
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindElements() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = MapViewModel.Input(trigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.cities.drive(cityBinding)
            .disposed(by: disposBag)
    }
    
    var cityBinding: Binder<Cities> {
        return Binder(self, binding: { (_ , city) in
            self.setupMapViewBy(lat: city.coord.lat, long: city.coord.lon)
        })
    }
    
    private func setupMapViewBy(lat: Double, long: Double) {
        // Set map region and add a pin
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: MapViewConstants.coordinate, longitudinalMeters: MapViewConstants.coordinate)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
}


