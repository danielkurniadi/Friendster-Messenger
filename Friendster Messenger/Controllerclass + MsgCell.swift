//  Friendster Messenger
//
//  Created by Student 3 on 1/7/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit
import CoreData

class FriendsterCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellID = "cellID"
    
    var messages : [FriendsterMessage]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recent"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = layout
        
        setupFriendsterData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
       
        if let message = messages?[indexPath.item]{
            cell.message = message
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let chatController = ChatLogController(collectionViewLayout: layout)

        chatController.friend = messages?[indexPath.item].toFriend
        navigationController?.pushViewController(chatController, animated: true)
    }
    
}


class MessageCell: BaseCell{
    
    var message : FriendsterMessage?{
        didSet{
            nameLabel.text = message?.toFriend?.name
            messageLabel.text = message?.text
            
            if let imageString = message?.toFriend?.profilePictString{
                profileImageView.image = UIImage(named: imageString)
                smallHasReadImageView.image = UIImage(named: imageString)
            }
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                
                let daytosecond : TimeInterval = 60*60*24
                let elapsedChatTime = NSDate().timeIntervalSince(date as Date)
                
                if (elapsedChatTime > 7*daytosecond){
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if (elapsedChatTime > daytosecond) {
                    dateFormatter.dateFormat = "EEE"
                } else {
                     dateFormatter.dateFormat = "h:mm a"
                }
               
                timeLabel.text = dateFormatter.string(for: date)
            }
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
//          print("highlighted mode is \(isHighlighted)")
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 255/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }

    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let lineDividerView : UIView = {
        let lineview = UIView()
        lineview.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return lineview
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Zuckerberg"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "You got a message from your friend and something else..."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let smallHasReadImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViewLayout() {
        addSubview(profileImageView)
        addSubview(lineDividerView)
        
        addContraintsWithFormat(hFormat: "H:|-82-[v0]-12-|", vFormat: "V:[v0(1)]|", views: lineDividerView)
        addContraintsWithFormat(hFormat: "H:|-12-[v0(68)]" , vFormat: "V:[v0(68)]", views: profileImageView)
        addConstraints([NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        setupContainerView()
    }
    
    private func setupContainerView(){
        let containerView = UIView()
        
        addSubview(containerView)
        addContraintsWithFormat(hFormat: "H:|-90-[v0]|", vFormat: "V:[v0(55)]", views: containerView)
        addConstraints([NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(smallHasReadImageView)
        
        addContraintsWithFormat(hFormat: "H:|[v0][v2(80)]-12-|", vFormat: "V:|[v0]-10-[v1(20)]|", views: nameLabel,messageLabel, timeLabel)
        addContraintsWithFormat(hFormat: "H:|[v0]-5-[v1(20)]-12-|", vFormat: "V:[v1(20)]|", views: messageLabel, smallHasReadImageView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(24)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel]))
        
    }
}

extension UIView{
    
    func addContraintsWithFormat(hFormat: String, vFormat: String, views: UIView...){
        var formatDict = [String : UIView]()
        
        for (index,viewItem) in views.enumerated(){
            formatDict["v\(index)"] = viewItem
            viewItem.translatesAutoresizingMaskIntoConstraints = false
        }
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: NSLayoutFormatOptions(), metrics: nil, views: formatDict))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: NSLayoutFormatOptions(), metrics: nil, views: formatDict))
    }
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("InitCoder hasn't been implemented yet")
    }
    
    func setupViewLayout(){
        backgroundColor = UIColor.white
    }
}



