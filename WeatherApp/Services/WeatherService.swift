import Foundation
import Alamofire

typealias Handler = (Result<InfoModel, AFError>) -> Void

struct WeatherService{
    
    // MARK: - Public Properties
    
    static let shared = WeatherService()
    
    //MARK: - Private Properties
    
    private let apiKey = "51f741f4caade0d11f858a659baf357b"
    private let url = "http://api.openweathermap.org/data/2.5/weather"
    private let queue = DispatchQueue(label: "decodable", qos: .userInitiated)
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
          let userInfo = ["date": Date()]
          return CachedURLResponse(
            response: response.response,
            data: response.data,
            userInfo: userInfo,
            storagePolicy: .allowed)
        })
        let queue = DispatchQueue(label: "request", qos: .userInitiated)
        return Session(
          configuration: configuration,
            requestQueue: queue, cachedResponseHandler: responseCacher)
    }()
    
    // MARK: - Public Methods
    
    func getWeather(_ parameters : [String : String], complete: @escaping Handler) {
        var parameters = parameters
        parameters["appid"] = apiKey
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
