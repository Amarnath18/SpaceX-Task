//
//  LaunchListViewController.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//

import UIKit

class LaunchListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    var launches: [Launch] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavViewShadow()
        fetchLaunches()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateNavViewShadowPath()
    }
    func setupNavViewShadow() {
        navView.layer.shadowColor = UIColor.black.cgColor
        navView.layer.shadowOpacity = 0.5
        navView.layer.shadowOffset = CGSize(width: 0, height: 2)
        navView.layer.shadowRadius = 4
        navView.layer.masksToBounds = false
    }
    
    func updateNavViewShadowPath() {
        navView.layer.shadowPath = UIBezierPath(rect: navView.bounds).cgPath
    }
    func fetchLaunches() {
        
        showLoadingIndicator()
        
        SpaceXService.shared.fetchLaunches { result in
            
            self.hideLoadingIndicator()
            
            switch result {
            case .success(let launches):
                self.launches = launches
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                // Fetch from Core Data when there's an error
                           self.launches = SpaceXService.shared.fetchLaunchesFromCoreData() // Modified to fetch from Core Data
                           DispatchQueue.main.async {
                               self.tableView.reloadData()
                           }
            }
        }
    }
    
    // Added showLoadingIndicator function
     func showLoadingIndicator() {
         DispatchQueue.main.async {
             self.activityIndicator.startAnimating()
         }
     }

     // Added hideLoadingIndicator function
     func hideLoadingIndicator() {
         DispatchQueue.main.async {
             self.activityIndicator.stopAnimating()
         }
     }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LaunchListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchTableViewCell", for: indexPath) as? LaunchTableViewCell else {
            return UITableViewCell()
        }
        let launch = launches[indexPath.row]
        cell.configure(with: launch)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = launches[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "LaunchDetailViewController") as? LaunchDetailViewController {
            detailVC.launch = launch
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

