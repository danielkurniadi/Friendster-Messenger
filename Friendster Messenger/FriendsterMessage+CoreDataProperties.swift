//
//  FriendsterMessage+CoreDataProperties.swift
//  Friendster Messenger
//
//  Created by Student 3 on 22/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendsterMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsterMessage> {
        return NSFetchRequest<FriendsterMessage>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var toFriend: FriendsterFriend?

}
