//
//  AirlineTableViewCell.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit

protocol AirlineTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(for cell: AirlineTableViewCell)
}

class AirlineTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgAirlineLogo: UIImageView!
    @IBOutlet weak var lblAirLineName: UILabel!
    @IBOutlet weak var btnAddToFav: UIButton!
    
    weak var delegate: AirlineTableViewCellDelegate?
    
    func setUpCell(photo: UIImage, name: String, isFavorited: Bool) {
        imgAirlineLogo.image = photo
        lblAirLineName.text = name
        
        let heartImage = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        btnAddToFav.setImage(heartImage, for: .normal)
        
        btnAddToFav.configuration?.showsActivityIndicator = false
    }
    
    
    @IBAction func addToFavBtn(_ sender: UIButton) {
        var config = sender.configuration ?? UIButton.Configuration.plain()
        config.showsActivityIndicator = true
        sender.configuration = config
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.didTapFavoriteButton(for: self)
        }
    }
    
    func stopActivityIndicator() {
        var config = btnAddToFav.configuration ?? UIButton.Configuration.plain()
        config.showsActivityIndicator = false
        btnAddToFav.configuration = config
    }
    
}

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }


//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
