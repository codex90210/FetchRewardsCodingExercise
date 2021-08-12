//
//  seatGeekModel.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/6/21.
//

// API Model
// API Model is utilized to format the API request for an array
import Foundation
import UIKit

struct seatGeekData {
    let eventID: Int
    let eventTitle: String
    let eventLocation: String
    let eventDate: String
    let eventImg: String
    let tbdStatus: Bool
}
