//
//  ViewController.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentOT: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var isPresentAllData = true
    var allAirlines: [AirlinePojo] = []
    var displayedAirlines: [AirlinePojo] = []
    var favorites: Set<String> = []
    let airlineService = AirlineService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        fetchAirlines()
        fetchFavorites()
    }
    
    func fetchFavorites() {
        favorites = CoreDataHelper.shared.fetchFavorites()
        updateDisplayedAirlines()
    }
    
    func fetchAirlines() {
        airlineService.fetchAirlines { [weak self] airlines, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let airlines = airlines {
                DispatchQueue.main.async {
                    self.allAirlines = airlines
                    self.updateDisplayedAirlines()
                }
            }
        }
    }
    
    func updateDisplayedAirlines() {
        if isPresentAllData {
            displayedAirlines = allAirlines
        } else {
            displayedAirlines = allAirlines.filter { favorites.contains($0.name) }
        }
        tableView.reloadData()
    }

    @IBAction func segmentChange(_ sender: Any) {
        switch segmentOT.selectedSegmentIndex {
        case 0:
            isPresentAllData = true
        case 1:
            isPresentAllData = false
        default:
            break
        }
        updateDisplayedAirlines()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedAirlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airlineCell", for: indexPath) as! AirlineTableViewCell
        let airline = displayedAirlines[indexPath.row]
        
        let isFavorited = favorites.contains(airline.name)
        
        cell.setUpCell(photo: UIImage(systemName: "airplane")!, name: airline.name, isFavorited: isFavorited)
        loadImage(for: airline.logoURL, into: cell)
        
        cell.delegate = self
        
        return cell
    }
    
    private func loadImage(for urlString: String, into cell: AirlineTableViewCell) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.setUpCell(photo: image, name: cell.lblAirLineName.text ?? "", isFavorited: false)
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAirline = displayedAirlines[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsOfAirline") as? DetailsOfAirline {
            detailsVC.airline = selectedAirline
            detailsVC.delegate = self
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension ViewController: AirlineTableViewCellDelegate, DetailsOfAirlineDelegate {
    func didTapFavoriteButton(for cell: AirlineTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let airline = displayedAirlines[indexPath.row]
            
            if favorites.contains(airline.name) {
                favorites.remove(airline.name)
                CoreDataHelper.shared.removeFavorite(name: airline.name)
            } else {
                favorites.insert(airline.name)
                CoreDataHelper.shared.addFavorite(name: airline.name, site: airline.site)
            }
            
            DispatchQueue.main.async {
                cell.stopActivityIndicator()
                self.updateDisplayedAirlines()
            }
        }
    }
    
    func didUpdateFavoriteStatus() {
        fetchFavorites()
    }
}


