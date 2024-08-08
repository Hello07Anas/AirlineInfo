//
//  ViewController.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var segmentOT: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var isPresentAllData = true
    var allAirlines: [AirlinePojo] = []
    var displayedAirlines: [AirlinePojo] = []
    var favorites: Set<String> = []
    let airlineService = AirlineService()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupRefreshControl()
        fetchAirlines()
        fetchFavorites()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchAirlines()
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
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            if let airlines = airlines {
                self.allAirlines = airlines

                DispatchQueue.main.async {
                    self.fetchFavorites()
                    self.updateDisplayedAirlines()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func updateDisplayedAirlines() {
        displayedAirlines = isPresentAllData ? allAirlines : allAirlines.filter { favorites.contains($0.name) }
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

// MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedAirlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airlineCell", for: indexPath) as! AirlineTableViewCell
        let airline = displayedAirlines[indexPath.row]
        
        let isFavorited = favorites.contains(airline.name)
        
        cell.setUpCell(photo: UIImage(systemName: "airplane")!, name: airline.name, isFavorited: isFavorited)

        ImageLoader.loadImage(from: K.Test_Img, into: cell.imgAirlineLogo, placeholder: K.Placeholder_Img) { image in
            cell.setUpCell(photo: image ?? K.Placeholder_Img!, name: airline.name, isFavorited: isFavorited)
        }
        
//        ImageLoader.loadImage(from: airline.logoURL, into: cell.imgAirlineLogo, placeholder: K.Placeholder_Img) { image in
//            cell.setUpCell(photo: image ?? K.Placeholder_Img!, name: airline.name, isFavorited: isFavorited)
//        }// TODO: uncomment when api return valid URL and delete line 103 - 105
        
        cell.delegate = self
        
        return cell
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

// MARK: - AirlineTableViewCellDelegate & DetailsOfAirlineDelegate

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

            updateDisplayedAirlines()

        }
    }
    
    func didUpdateFavoriteStatus() {
        fetchFavorites()
    }
}
