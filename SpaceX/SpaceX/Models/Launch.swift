//
//  Launch.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//


import Foundation

struct Launch: Codable {
    let name: String
    let dateUTC: String
    let dateLocal: String
    let success: Bool?
    let failures: [Failure]
    let rocket: String
    let links: Links

    enum CodingKeys: String, CodingKey {
        case name
        case dateUTC = "date_utc"
        case dateLocal = "date_local"
        case success
        case failures
        case rocket
        case links
    }
}

struct Failure: Codable {
    let reason: String
}

struct Links: Codable {
    let patch: Patch?
    let flickr: Flickr?

    enum CodingKeys: String, CodingKey {
        case patch
        case flickr
    }
}

struct Patch: Codable {
    let small: String?
    let large: String?
}

struct Flickr: Codable {
    let original: [String]
}
