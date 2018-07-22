//
//  FriendsterFriend+CoreDataProperties.swift
//  Friendster Messenger
//
//  Created by Student 3 on 22/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendsterFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsterFriend> {
        return NSFetchRequest<FriendsterFriend>(entityName: "Friend")
    }

    @NSManaged public var name: String?
    @NSManaged public var profilePictString: String?
    @NSManaged public var toMessage: NSSet?

}

// MARK: Generated accessors for toMessage
extension FriendsterFriend {

    @objc(addToMessageObject:)
    @NSManaged public func addToToMessage(_ value: FriendsterMessage)

    @objc(removeToMessageObject:)
    @NSManaged public func removeFromToMessage(_ value: FriendsterMessage)

    @objc(addToMessage:)
    @NSManaged public func addToToMessage(_ values: NSSet)

    @objc(removeToMessage:)
    @NSManaged public func removeFromToMessage(_ values: NSSet)

}
