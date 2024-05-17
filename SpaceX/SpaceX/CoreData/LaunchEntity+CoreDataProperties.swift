//
//  LaunchEntity+CoreDataProperties.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//

import Foundation
import CoreData

extension LaunchEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LaunchEntity> {
        return NSFetchRequest<LaunchEntity>(entityName: "LaunchEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateUTC: String?
    @NSManaged public var dateLocal: String?
    @NSManaged public var success: Bool
    @NSManaged public var failures: Data?
    @NSManaged public var rocket: String?
    @NSManaged public var links: Data?
}
