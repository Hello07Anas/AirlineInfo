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
    var airlines: [Airline] = []
    var favorites: Set<String> = []
    let airlineService = AirlineService()
    //let favoritesManager = FavoritesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        fetchAirlines()
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
                    self.airlines = airlines
                    //self.favorites = self.favoritesManager.favorites
                    self.tableView.reloadData()
                }
            }
        }
    }


    @IBAction func segmentChange(_ sender: Any) {
        switch segmentOT.selectedSegmentIndex {
        case 0: // present All data
            isPresentAllData = true
            tableView.reloadData()
        case 1: // present Facorite
            isPresentAllData = false
            tableView.reloadData()
        default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        airlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airlineCell", for: indexPath) as! AirlineTableViewCell
        let airline = airlines[indexPath.row]
        
        
        cell.setUpCell(photo: UIImage(systemName: "airplane")!, name: airline.name, isFavorited: favorites.contains(airline.code))
        loadImage(for: airline.logoURL, into: cell)
        
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
        
        let selectedAirline = airlines[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsOfAirline") as? DetailsOfAirline {
            detailsVC.airline = selectedAirline
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}

