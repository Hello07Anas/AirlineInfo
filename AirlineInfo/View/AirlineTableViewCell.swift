//
//  AirlineTableViewCell.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit

class AirlineTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgAirlineLogo: UIImageView!
    @IBOutlet weak var lblAirLineName: UILabel!
    @IBOutlet weak var btnAddToFav: UIButton!
    
    func setUpCell(photo: UIImage, name: String, isFavorited: Bool) {
        imgAirlineLogo.image = photo
        lblAirLineName.text = name
        
        let heartImage = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        btnAddToFav.setImage(heartImage, for: .normal)
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
