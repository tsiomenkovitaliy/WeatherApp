import Foundation
import CoreLocation
import UIKit

final class LocationService: NSObject {
    
    //MARK: - Private Properties
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    } ()
    
    // MARK: - Public Properties
    
    static let shared = LocationService()
    var locationChange: ((CoordModel) -> ())?
    
    // MARK: - Public Methods
    
    func getCurrentLocation(){
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let lat = Float(location.coordinate.latitude)
            let lon = Float(location.coordinate.longitude)
            locationChange?(CoordModel(lon: lon, lat: lat))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways,
             .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted,
             .denied:
            guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(url)
        @unknown default:
            fatalError()
        }
    }
}
