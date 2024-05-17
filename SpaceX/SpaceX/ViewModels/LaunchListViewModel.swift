//
//  LaunchListViewModel.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//


import Foundation

class LaunchListViewModel {
    private var launches: [Launch] = []
    var reloadTableView: (() -> Void)?
    
    var numberOfLaunches: Int {
        return launches.count
    }
    
    func launchAt(index: Int) -> Launch {
        return launches[index]
    }
    
    func fetchLaunches() {
        SpaceXService.shared.fetchLaunches { [weak self] result in
            switch result {
            case .success(let launches):
                self?.launches = launches
                self?.reloadTableView?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
