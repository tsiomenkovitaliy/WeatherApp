import Foundation
import Alamofire

typealias Handler = (Result<InfoModel, AFError>) -> Void

struct WeatherService{
    
    // MARK: - Public Properties
    
    static let shared = WeatherService()
    
    //MARK: - Private Properties
    
    private let url = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "51f741f4caade0d11f858a659baf357b"
    private let units = "metric"
    private let lang = "RU"
    private let queue = DispatchQueue(label: "decod", qos: .userInitiated)
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        
        let queue = DispatchQueue(label: "request", qos: .userInitiated)
        return Session(
            configuration: configuration,
            requestQueue: queue)
    }()
    
    // MARK: - Public Methods
    
    func getWeather(_ param : [String : String], complete: @escaping Handler) {
        var parameters = param
        parameters.merge(zip(["appid","units","lang"], [apiKey,units,lang])) { $1 }
        request(parameters) { info in
            complete(info)
        }
    }
    
    // MARK: - Private Methods
    
    private func request(_ parameters: [String : String], complete: @escaping Handler) {
        sessionManager
            .request(url,parameters: parameters)
            .responseDecodable(of: InfoModel.self,
                               queue: queue) { response in
                
                DispatchQueue.main.async {
                    switch response.result{
                    case .failure(let error):
                        complete(.failure(error))
                    case .success(let info):
                        complete(.success(info))
                    }
                }
            }
    }
}
