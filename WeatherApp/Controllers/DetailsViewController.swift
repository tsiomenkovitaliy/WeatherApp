import UIKit

final class DetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var cityNameLbl: UILabel!
    @IBOutlet private weak var temperatureLbl: UILabel!
    
    // MARK: - Public Properties
    
    var viewModel: DetailsViewModel!

    //MARK: - Private Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLbl.text = viewModel.weatherInfo.name
        temperatureLbl.text = "\(String(viewModel.weatherInfo.main.temp))  °C"
    }
}
