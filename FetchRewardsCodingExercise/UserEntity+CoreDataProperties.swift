//
//  UserEntity+CoreDataProperties.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/11/21.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var savedLikedEvents: [Int]

}

extension UserEntity : Identifiable {

}
