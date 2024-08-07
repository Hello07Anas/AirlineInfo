//
//  AirlineService.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import Foundation

class AirlineService {
    func fetchAirlines(completion: @escaping ([Airline]?, Error?) -> Void) {
        guard let url = URL(string: K.Base_Url) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let airlines = try JSONDecoder().decode([Airline].self, from: data)
                completion(airlines, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
