//
//  ViewControllerManager.swift
//  AirlineInfo
//
//  Created by Anas Salah on 08/08/2024.
//

import Foundation

class AirlineManager {
    var allAirlines: [AirlinePojo] = []
    var favorites: Set<String> = []

    let airlineService = AirlineService()

    func fetchAirlines(completion: @escaping (Result<[AirlinePojo], Error>) -> Void) {
        airlineService.fetchAirlines { airlines, error in
            if let error = error {
                completion(.failure(error))
            } else if let airlines = airlines {
                self.allAirlines = airlines
                completion(.success(airlines))
            }
        }
    }

    func fetchFavorites() {
        favorites = CoreDataHelper.shared.fetchFavorites()
    }

    func updateDisplayedAirlines(isPresentAllData: Bool) -> [AirlinePojo] {
        return isPresentAllData ? allAirlines : allAirlines.filter { favorites.contains($0.name) }
    }

    func toggleFavorite(for airlineName: String) {
        if favorites.contains(airlineName) {
            favorites.remove(airlineName)
            CoreDataHelper.shared.removeFavorite(name: airlineName)
        } else {
            favorites.insert(airlineName)
            CoreDataHelper.shared.addFavorite(name: airlineName, site: airlineName)
        }
    }
}
