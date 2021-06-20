import UIKit
import Kingfisher

final class DetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var cityNameLbl: UILabel!
    @IBOutlet private weak var temperatureLbl: UILabel!
    @IBOutlet private weak var imageWeatherView: UIImageView!
    
    // MARK: - Public Properties
    
    var viewModel: DetailsViewModel!
    
    //MARK: - Private Properties
    
    private let imageServer = "http://openweathermap.org/img/wn/"

    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    //MARK: - Private Properties
    
    func setData() {
        guard let weatherInfo = viewModel.weatherInfo else { return }
        
        cityNameLbl.text = weatherInfo.name
        temperatureLbl.text = "\(String(weatherInfo.main.temp))  °C"
        
        guard let weather = weatherInfo.weather.first,
              let url = URL(string: "\(imageServer + weather.icon)@2x.png")
        else { return }
        imageWeatherView.kf.setImage(with: url)
    }
}
