//
//  LaunchEntity+CoreDataClass.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//

import Foundation
import CoreData

@objc(LaunchEntity)
public class LaunchEntity: NSManagedObject {
    func toLaunch() -> Launch? {
        guard let name = name,
              let dateUTC = dateUTC,
              let dateLocal = dateLocal,
              let rocket = rocket,
              let linksData = links,
              let failuresData = failures else {
            return nil
        }

        let decoder = JSONDecoder()
        let links = try? decoder.decode(Links.self, from: linksData)
        let failures = try? decoder.decode([Failure].self, from: failuresData)
        
        return Launch(name: name, dateUTC: dateUTC, dateLocal: dateLocal, success: success, failures: failures ?? [], rocket: rocket, links: links ?? Links(patch: nil, flickr: nil))
    }
}

extension Launch {
    func toLaunchEntity(context: NSManagedObjectContext) -> LaunchEntity {
        let entity = LaunchEntity(context: context)
        entity.name = name
        entity.dateUTC = dateUTC
        entity.dateLocal = dateLocal
        entity.success = success ?? false
        entity.rocket = rocket
        entity.failures = try? JSONEncoder().encode(failures)
        entity.links = try? JSONEncoder().encode(links)
        return entity
    }
}
