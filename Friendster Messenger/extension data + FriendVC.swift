//
//  extension FriendVC.swift
//  Friendster Messenger
//
//  Created by Student 3 on 1/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//
import Foundation
import UIKit
import CoreData

extension FriendsterCollectionController{
    
    func clearFriendsterData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            do{
                let entityNames = ["Message", "Friend"]
                for entity in entityNames{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    let objects = try(context.fetch(fetchRequest) as? [NSManagedObject])
                    for object in objects! {context.delete(object)}
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupFriendsterData(){
        clearFriendsterData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
        // Mark ZuckerBerg
            let markz = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! FriendsterFriend
            markz.name = "Mark Zuckerberg"
            markz.profilePictString = "zuckprofile"
            
           _ = FriendsterCollectionController.createDummyMessage(friend: markz, textMsg: "Boy, your app looks familiar. Keep the good work.", minutesAgo: 3 ,context: context)
            
        // Steve Job
            createSteveChatMessage(context: context)

        // Donald Trump
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! FriendsterFriend
            donald.name = "Donald Trump"
            donald.profilePictString = "donald_trump_profile"
            
           _ = FriendsterCollectionController.createDummyMessage(friend: donald, textMsg: "Those annoying immigrants coffvevfe", minutesAgo: 60*36 ,context: context)
            
            // Mahatma Gandhi
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! FriendsterFriend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profilePictString = "gandhi"
            
            _ = FriendsterCollectionController.createDummyMessage(friend: gandhi, textMsg: "Love, Peace, & Hope", minutesAgo: 60*77 ,context: context)
           
            // Hillary Clinton
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! FriendsterFriend
            hillary.name = "Hillary Clinton"
            hillary.profilePictString = "hillary_profile"
            _ = FriendsterCollectionController.createDummyMessage(friend: hillary, textMsg: "Vote for me, you did for Bill", minutesAgo: 60*24*7 ,context: context)
            
            // Save context
            do{
                try context.save()
            } catch let err {
                print(err)
            }
        }
        loadFriendsterData()
    }
    
    private func createSteveChatMessage(context: NSManagedObjectContext){
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! FriendsterFriend
        steve.name = "Steve Job"
        steve.profilePictString = "steve_profile"

        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Hi there, good morning", minutesAgo: 75 ,context: context)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Boy, are you crazy enough to change the world? Apple co is looking for genius lead like you! Drop your CV anytime to me.", minutesAgo: 72 ,context: context)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Apple WWDC 2019 is happening soon! Sign up today to get your VIP seat. If you are interested, please visit Apple WWDC 2019 website and register yourself. Free admision fee for those who have apple developer.", minutesAgo: 30 ,context: context)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Yeap excited to begin my adventure with apple. ", minutesAgo: 29 ,context: context, isSender: true)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "I just dropped my CV to your email. Check out my awesome experience from being a Google Jam top rank scorer!", minutesAgo: 25 ,context: context, isSender: true)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Alright we will be back to you in a couple days son...", minutesAgo: 15 ,context: context)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Good luck !", minutesAgo: 10 ,context: context)
        _ = FriendsterCollectionController.createDummyMessage(friend: steve, textMsg: "Hey son, you got an interview next month with Tim Cook! Kudos for you and don't forget to be awesome.", minutesAgo: 2 ,context: context)
    }
    
    static func createDummyMessage(friend: FriendsterFriend, textMsg: String, minutesAgo: Double, context: NSManagedObjectContext, isSender : Bool = false)->FriendsterMessage{
    
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! FriendsterMessage
        message.toFriend = friend
        message.text = textMsg
        message.date = NSDate().addingTimeInterval(-minutesAgo*60)
        message.isSender = isSender
        return message
    }
        
    func loadFriendsterData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if let fecthedFriends = fetchFriendData() {
                
                messages = [FriendsterMessage]()
                
                for fetchedFriend in fecthedFriends{
//                    print(fetchedFriend.name)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "toFriend.name = %@", fetchedFriend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do{
                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [FriendsterMessage]
                        messages?.append(contentsOf: fetchedMessages!)
                    } catch let err {
                        print(err)
                    }
                }
                messages?.sort(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
        }
    }
    
    func fetchFriendData() -> [FriendsterFriend]?{
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do{
                return try(context.fetch(fetchrequest) as? [FriendsterFriend])!
            
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    
    
}
