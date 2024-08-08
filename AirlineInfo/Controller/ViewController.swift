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
    var displayedAirlines: [AirlinePojo] = []
    let airlineManager = AirlineManager()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupRefreshControl()
        fetchAirlines()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchAirlines()
    }
    
    func fetchAirlines() {
        airlineManager.fetchAirlines { [weak self] result in
            switch result {
            case .success(_):
                self?.airlineManager.fetchFavorites()
                self?.updateDisplayedAirlines()
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateDisplayedAirlines() {
        displayedAirlines = airlineManager.updateDisplayedAirlines(isPresentAllData: isPresentAllData)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        
        let isFavorited = airlineManager.favorites.contains(airline.name)
        
        cell.setUpCell(photo: UIImage(systemName: "airplane")!, name: airline.name, isFavorited: isFavorited)

        //ImageLoader.loadImage(from: airline.logoURL, into: cell.imgAirlineLogo, placeholder: K.Placeholder_Img) { image in
        //cell.setUpCell(photo: image ?? K.Placeholder_Img!, name: airline.name, isFavorited: isFavorited)
        //}// TODO: uncomment when api return valid URL and delete next  ImageLoader
        
        ImageLoader.loadImage(from: K.Test_Img, into: cell.imgAirlineLogo, placeholder: K.Placeholder_Img) { image in
            cell.setUpCell(photo: image ?? K.Placeholder_Img!, name: airline.name, isFavorited: isFavorited)
        }
        
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
            airlineManager.toggleFavorite(for: airline.name)
            updateDisplayedAirlines()
        }
    }
    
    func didUpdateFavoriteStatus() {
        fetchAirlines()
    }
}
