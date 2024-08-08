//
//  DetailsOfAirline.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit

protocol DetailsOfAirlineDelegate: AnyObject {
    func didUpdateFavoriteStatus()
}

class DetailsOfAirline: UIViewController {
    
    var airline: AirlinePojo?
    var isFavorited = false
    weak var delegate: DetailsOfAirlineDelegate?
    
    @IBOutlet weak var imgAirline: UIImageView!
    @IBOutlet weak var btnIsFavorited: UIButton!
    @IBOutlet weak var lblNameAirline: UILabel!
    @IBOutlet weak var btnURL: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let logoURLString = airline?.logoURL, let logoURL = URL(string: logoURLString) {
            let placeholderImage = UIImage(systemName: "airplane")
            imgAirline.loadImage(from: logoURL, placeholder: placeholderImage)
        }
        
        btnURL.titleLabel?.text = airline?.site
        lblNameAirline.text = airline?.name
        
        if let airlineName = airline?.name {
            isFavorited = CoreDataHelper.shared.fetchFavorites().contains(airlineName)
        }
        
        updateFavoriteButtonImage()
    }
    
    private func updateFavoriteButtonImage() {
        let heartImage = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        btnIsFavorited.setImage(heartImage, for: .normal)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        delegate?.didUpdateFavoriteStatus()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callNumberBtn(_ sender: Any) {
        let phoneNumber = "+201274348083" //all links return number = "" so it defult number
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                CustoumAlert.showAlert(title: "Error", message: "Your device cannot make phone calls.", preferredStyle: .alert, from: self)
            }
        } else {
            CustoumAlert.showAlert(title: "Error", message: "Invalid phone number URL.", preferredStyle: .alert, from: self)
        }
    }
    
    
    @IBAction func openURLBtn(_ sender: Any) {
        guard let airline = airline else {
            CustoumAlert.showAlert(title: "Error", message: "Airline information is missing.", preferredStyle: .alert, from: self)
            return
        }
        
        let urlString = airline.site
        
        if !urlString.isEmpty, let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                CustoumAlert.showAlert(title: "Error", message: "Your device cannot open this URL.", preferredStyle: .alert, from: self)
            }
        } else {
            CustoumAlert.showAlert(title: "Error", message: "Invalid URL.", preferredStyle: .alert, from: self)
        }
    }
    
    @IBAction func addToFavBtn(_ sender: UIButton) {
        var config = sender.configuration ?? UIButton.Configuration.plain()
        config.showsActivityIndicator = true
        sender.configuration = config
        
        sender.setNeedsUpdateConfiguration()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let airlineName = self.airline?.name else { return }
            
            if self.isFavorited {
                CoreDataHelper.shared.removeFavorite(name: airlineName)
                self.isFavorited = false
            } else {
                CoreDataHelper.shared.addFavorite(name: airlineName, site: self.airline?.site ?? "")
                self.isFavorited = true
            }
            
            self.updateFavoriteButtonImage()
            
            var config = sender.configuration ?? UIButton.Configuration.plain()
            config.showsActivityIndicator = false
            sender.configuration = config
        }
    }


}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
