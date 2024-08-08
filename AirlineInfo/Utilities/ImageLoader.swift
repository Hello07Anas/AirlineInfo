//
//  ImageLoader.swift
//  AirlineInfo
//
//  Created by Anas Salah on 08/08/2024.
//

import UIKit
import SDWebImage

struct ImageLoader {
    static func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            imageView.image = placeholder
            completion?(nil)
            return
        }
        
        imageView.sd_setImage(with: url, placeholderImage: placeholder) { image, error, cacheType, url in
            completion?(image)
        }
    }
}
