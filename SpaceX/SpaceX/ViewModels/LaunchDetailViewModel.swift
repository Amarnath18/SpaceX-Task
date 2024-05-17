//
//  LaunchDetailViewModel.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//


import Foundation

class LaunchDetailViewModel {
    let launch: Launch

    private let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale =  Locale.init(identifier: formatter.locale.identifier)
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    init(launch: Launch) {
        self.launch = launch
    }

    var missionName: String {
        return launch.name
    }

    var localDate: String {
        guard let date = inputDateFormatter.date(from: launch.dateLocal) else {
            return "Invalid date"
        }
        return displayDateFormatter.string(from: date)
    }

    var successStatus: String {
        if let success = launch.success {
            return success ? "Success" : "Failed"
        } else {
            return "Unknown"
        }
    }

    var failureReason: String {
        if let firstFailure = launch.failures.first {
            return "Failure Reason: \(firstFailure.reason)"
        } else {
            return "Failure Reason: N/A"
        }
    }

    var rocketName: String {
        return launch.rocket
    }

    var patchImageUrl: URL? {
        if let imageUrl = launch.links.patch?.large {
            return URL(string: imageUrl)
        }
        return nil
    }
}
