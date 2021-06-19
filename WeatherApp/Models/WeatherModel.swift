import Foundation

struct WeatherModel : Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
