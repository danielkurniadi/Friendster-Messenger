//
//  Friendster_MessengerFriend+CoreDataProperties.swift
//  Friendster Messenger
//
//  Created by Student 3 on 2/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//
//

import Foundation
import CoreData


extension Friendster_MessengerFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friendster_MessengerFriend> {
        return NSFetchRequest<Friendster_MessengerFriend>(entityName: "Friend")
    }

    @NSManaged public var name: String?
    @NSManaged public var profilePictString: String?
    @NSManaged public var toMessage: NSSet?

}

// MARK: Generated accessors for toMessage
extension Friendster_MessengerFriend {

    @objc(addToMessageObject:)
    @NSManaged public func addToToMessage(_ value: Friendster_MessengerMessage)

    @objc(removeToMessageObject:)
    @NSManaged public func removeFromToMessage(_ value: Friendster_MessengerMessage)

    @objc(addToMessage:)
    @NSManaged public func addToToMessage(_ values: NSSet)

    @objc(removeToMessage:)
    @NSManaged public func removeFromToMessage(_ values: NSSet)

}
