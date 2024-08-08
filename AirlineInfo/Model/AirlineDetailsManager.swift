//
//  AirlineDetailsManager.swift
//  AirlineInfo
//
//  Created by Anas Salah on 08/08/2024.
//

import Foundation

class AirlineDetailsManager {
    private let coreDataHelper = CoreDataHelper.shared
    
    func isFavorited(name: String) -> Bool {
        return coreDataHelper.fetchFavorites().contains(name)
    }
    
    func addFavorite(name: String, site: String) {
        coreDataHelper.addFavorite(name: name, site: site)
    }
    
    func removeFavorite(name: String) {
        coreDataHelper.removeFavorite(name: name)
    }
}
