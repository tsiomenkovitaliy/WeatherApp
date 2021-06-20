import Foundation

final class MainViewModel {
    
    // MARK: - Public Properties
    
    var propertyChanged: (() -> ())?
    
    var text = String(){
        didSet{ dataChanged() }
    }
    private (set) var searchIsDisable: Bool = true {
        didSet{ propertyChanged?() }
    }
    
    // MARK: - Private Properties
    
    private var coord: CoordModel?
    
    // MARK: - Initializers
    
    init() {
        settingsLocationService()
    }
    
    // MARK: - Public Methods
    
    func getCurrentLocation(){
        LocationService.shared.getCurrentLocation()
    }
    
    func getWeather(_ complete : @escaping Handler) {
        var parameters: [String: String] = [:]
        
        if text.isEmpty, let coord  = coord {
            parameters["lat"] = String(coord.lat)
            parameters["lon"] = String(coord.lon)
        } else {
            parameters["q"] = text
        }
        
        WeatherService.shared.getWeather(parameters) { info in
            complete(info)
        }
    }
    
    // MARK: - Private Methods
    
    private func settingsLocationService(){
        LocationService.shared.locationChange = { [weak self] coord in
            guard let self = self else { return }
            self.coord = coord
            self.dataChanged()
        }
    }
    
    private func dataChanged(){
        searchIsDisable = text.isEmpty && coord == nil
    }
}
