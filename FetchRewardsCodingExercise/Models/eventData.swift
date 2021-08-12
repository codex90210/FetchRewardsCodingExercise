//
//  eventData.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/8/21.
//

// Event Title, Location, Date, Image, Event ID
// Struct that is formated accoriding to the JSON external API design
import Foundation

struct eventData: Decodable {
    let events: [Events]
}

struct Events: Decodable {
    let id: Int
    let venue: Venues
    let title: String
    let datetime_local: String
    let performers: [Performers]
    let time_tbd: Bool
}

struct Venues: Decodable {
    let display_location: String
}

struct Performers: Decodable {
    let image: String
}
