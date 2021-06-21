import Foundation

struct InfoModel : Decodable {
    let coord: CoordModel
    let weather: [WeatherModel]
    let base: String
    let main: MainModel
    let visibility: Int
    let wind: WindModel
    let clouds: CloudsModel
    let dt: Int
    let sys: SysModel
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
