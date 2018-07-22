//
//  Friendster_MessengerMessage+CoreDataProperties.swift
//  Friendster Messenger
//
//  Created by Student 3 on 2/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//
//

import Foundation
import CoreData


extension Friendster_MessengerMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friendster_MessengerMessage> {
        return NSFetchRequest<Friendster_MessengerMessage>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var toFriend: Friendster_MessengerFriend?

}
