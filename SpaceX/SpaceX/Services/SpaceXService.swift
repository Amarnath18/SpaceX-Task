//
//  SpaceXService.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//


import Foundation
import Alamofire
import CoreData
import Reachability

class SpaceXService {
    static let shared = SpaceXService()
    private let baseURL = "https://api.spacexdata.com/v4/launches"
    private let persistentContainer: NSPersistentContainer
    private let reachability = try! Reachability()

    init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func fetchLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        if reachability.connection != .unavailable {
            AF.request(baseURL).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let launches = try decoder.decode([Launch].self, from: data)
                        self.saveLaunchesToCoreData(launches: launches)
                        completion(.success(launches))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let launches = fetchLaunchesFromCoreData()
            if launches.isEmpty {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection and no cached data available"])))
            } else {
                completion(.success(launches))
            }
        }
    }
    
    private func saveLaunchesToCoreData(launches: [Launch]) {
         let context = persistentContainer.viewContext
         launches.forEach { launch in
             let entity = LaunchEntity(context: context)
             entity.name = launch.name
             entity.dateUTC = launch.dateUTC
             entity.dateLocal = launch.dateLocal
             entity.success = launch.success ?? false
             entity.rocket = launch.rocket

             let encoder = JSONEncoder()
             entity.failures = try? encoder.encode(launch.failures) // Added to store failures
             entity.links = try? encoder.encode(launch.links) // Added to store links
         }
         do {
             try context.save()
         } catch {
             print("Failed to save launches: \(error)")
         }
     }
    
    func fetchLaunchesFromCoreData() -> [Launch] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LaunchEntity> = LaunchEntity.fetchRequest()
        
        do {
            let launchEntities = try context.fetch(fetchRequest)
            return launchEntities.compactMap { $0.toLaunch() } // Modified to use toLaunch() method
        } catch {
            print("Failed to fetch launches: \(error)")
            return []
        }
    }
}



//import Foundation
//import Alamofire
//import CoreData
//
//class SpaceXService {
//    static let shared = SpaceXService()
//    private let baseURL = "https://api.spacexdata.com/v4/launches"
//    private let persistentContainer: NSPersistentContainer
//    
//    init() {
//        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
//    }
//
//    func fetchLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
//        AF.request(baseURL).responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    let launches = try decoder.decode([Launch].self, from: data)
//                    self.saveLaunchesToCoreData(launches: launches)
//                    completion(.success(launches))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    private func saveLaunchesToCoreData(launches: [Launch]) {
//        let context = persistentContainer.viewContext
//        launches.forEach { launch in
//            _ = launch.toLaunchEntity(context: context)
//        }
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save launches: \(error)")
//        }
//    }
//    
//    func fetchLaunchesFromCoreData() -> [Launch] {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<LaunchEntity> = LaunchEntity.fetchRequest()
//        
//        do {
//            let launchEntities = try context.fetch(fetchRequest)
//            return launchEntities.compactMap { $0.toLaunch() }
//        } catch {
//            print("Failed to fetch launches: \(error)")
//            return []
//        }
//    }
//}
