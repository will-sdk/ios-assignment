

import UIKit
import MapKit
import SnapKit
import Domain
import RxSwift

struct MapViewConstants {
    static let coordinate: Double = 1000
    static let titleLabelSize: CGFloat = 17
    static let subtitleLabelSize: CGFloat = 13
    static let navBarHeight = 44
}

class MapViewController: UIViewController {
    
    var viewModel: MapViewModel!
    
    let disposBag = DisposeBag()
    let mapView = MKMapView()
    var subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindElements()
    }
    
    private func setupViews() {
        // Add navigation bar
        let navBar = UINavigationBar()
        navBar.barTintColor = .white
        navBar.isTranslucent = false
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(MapViewConstants.navBarHeight)
        }
        
        // Add navigation bar title and subtitle
        let navItem = UINavigationItem(title: "")
        navBar.setItems([navItem], animated: false)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: MapViewConstants.titleLabelSize)
        navItem.titleView = titleLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: MapViewConstants.subtitleLabelSize)
        subtitleLabel.textColor = .gray
        subtitleLabel.text = ""
        navItem.titleView?.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Add map view to the view
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func bindElements() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = MapViewModel.Input(trigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.citySearchItem.drive(cityBinding)
            .disposed(by: disposBag)
    }
    
    var cityBinding: Binder<CitySearchItemViewModel> {
        return Binder(self, binding: { (_ , city) in
            self.setupMapViewBy(lat: city.lat, long: city.long)
            self.navigationItem.title = city.cityAndCountry
            self.subtitleLabel.text = city.latAndlong
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


