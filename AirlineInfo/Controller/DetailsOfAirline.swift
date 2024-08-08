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
    
    private let airlineDetailsManager = AirlineDetailsManager()
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
            setupUI()
        }
        
        private func setupUI() {
            guard let airline = airline else {
                showErrorAlert(title: "Error", message: "Airline information is missing.")
                return
            }
            
            //ImageLoader.loadImage(from: logoURLString, into: imgAirline, placeholder: K.Placeholder_Image)// TODO: uncomment when api return valid URL and delete next line
            ImageLoader.loadImage(from: K.Test_Img, into: imgAirline, placeholder: K.Placeholder_Img)

            lblNameAirline.text = airline.name
            btnURL.setTitle(airline.site, for: .normal)
            updateFavoriteButtonImage()
        }
        
        private func updateFavoriteButtonImage() {
            guard let airlineName = airline?.name else { return }
            let heartImage = airlineDetailsManager.isFavorited(name: airlineName) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            btnIsFavorited.setImage(heartImage, for: .normal)
        }
        
        @IBAction func backBtn(_ sender: Any) {
            delegate?.didUpdateFavoriteStatus()
            navigationController?.popViewController(animated: true)
        }
        
        @IBAction func callNumberBtn(_ sender: Any) {
            let phoneNumber = "+201274348083" // default number
            if let phoneURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                showErrorAlert(title: "Error", message: "Invalid phone number URL or your device cannot make phone calls.")
            }
        }
        
        @IBAction func openURLBtn(_ sender: Any) {
            guard let urlString = airline?.site, let url = URL(string: urlString), !urlString.isEmpty, UIApplication.shared.canOpenURL(url) else {
                showErrorAlert(title: "Error", message: "Invalid URL or your device cannot open this URL.")
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        @IBAction func addToFavBtn(_ sender: UIButton) {
            var config = sender.configuration ?? UIButton.Configuration.plain()
            config.showsActivityIndicator = true
            sender.configuration = config
            sender.setNeedsUpdateConfiguration()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                guard let airlineName = self.airline?.name else { return }
                
                if self.airlineDetailsManager.isFavorited(name: airlineName) {
                    self.airlineDetailsManager.removeFavorite(name: airlineName)
                } else {
                    self.airlineDetailsManager.addFavorite(name: airlineName, site: self.airline?.site ?? "")
                }
                
                self.updateFavoriteButtonImage()
                
                var config = sender.configuration ?? UIButton.Configuration.plain()
                config.showsActivityIndicator = false
                sender.configuration = config
            }
        }
        
        private func showErrorAlert(title: String, message: String) {
            CustoumAlert.showAlert(title: title, message: message, preferredStyle: .alert, from: self)
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
