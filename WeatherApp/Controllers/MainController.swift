import UIKit

final class MainController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchButton: UIButton!
    
    //MARK: - Private Properties
    
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        viewModel.propertyChanged = { [weak self] in
            self?.searchButton.isEnabled = !viewModel.searchIsDisable
        }
        return viewModel
    }()
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsSearchBar()
    }
    
    // MARK: - Private Methods
    
    private func settingsSearchBar(){
        searchBar.delegate = self
    }
    
    private func getDetailsVC(_ info: InfoModel) -> DetailsViewController?{
        let  mainView = UIStoryboard(name:"Main", bundle: nil)
        
        guard let detailsVC = mainView.instantiateViewController(withIdentifier: "DetailsViewController")
                as? DetailsViewController else { return nil }
        
        let viewModel = DetailsViewModel()
        viewModel.weatherInfo = info
        detailsVC.viewModel = viewModel
        return detailsVC
    }
    
    // MARK: - IBActions
    
    @IBAction func getWeather(_ sender: Any) {
        viewModel.getWeather() { [weak self] info in
            guard let self = self else { return }
            
            switch info{
            case .failure:
                self.searchBar.backgroundColor = .red
            case .success(let info):
                self.searchBar.backgroundColor = .clear

                guard let detailsVC = self.getDetailsVC(info) else { return }
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        viewModel.getCurrentLocation()
    }
}

//MARK: - UISearchBarDelegate

extension MainController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.text = searchText
    }
}
