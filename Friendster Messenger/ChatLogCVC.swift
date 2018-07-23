//
//  ChatLogController.swift
//  Friendster Messenger
//
//  Created by Student 3 on 2/7/18.
//  Copyright © 2018 Student 3. All rights reserved.

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var cellID = "chatCellID"
    
    // ep 4
    var messages : [FriendsterMessage]?
    var friend : FriendsterFriend?{
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.toMessage?.allObjects as? [FriendsterMessage]
            messages?.sort(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }

    // ep 7
    let inputTextField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter message..."
        return textfield
    }()
    
    // ep 7
    let messageInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    var bottomContraint : NSLayoutConstraint!
    var realkeyboardheight: Int = 0
    
    @objc func handleSend(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext, let inputText = inputTextField.text{
            let newMessage = FriendsterCollectionController.createDummyMessage(friend: friend!, textMsg: inputText, minutesAgo: 0, context: context, isSender: true)
            do {
                messages?.append(newMessage)
                let item = messages!.count-1
                let insertionIndexPath = IndexPath(item: item, section: 0)
                collectionView?.insertItems(at: [insertionIndexPath])
                collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: true)
                inputTextField.text = nil
                try context.save()
            }catch let err{
                print(err)
            }
        }
    }
    
    // ep 4
    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBarController?.tabBar.isHidden = true
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellID)
        
        setupInputTextLayout()
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    private func setupInputTextLayout(){
        let topBorderInputView = UIView()
        topBorderInputView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        view.addSubview(messageInputContainer)
        view.addContraintsWithFormat(hFormat: "H:|-8-[v0]|", vFormat: "V:[v0(64)]", views: messageInputContainer)
        bottomContraint = NSLayoutConstraint(item: messageInputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomContraint)
        
        messageInputContainer.addSubview(inputTextField)
        messageInputContainer.addSubview(sendButton)
        messageInputContainer.addSubview(topBorderInputView)
        
        messageInputContainer.addContraintsWithFormat(hFormat: "H:|[v0][v1(80)]|", vFormat: "V:|[v0]|", views: inputTextField, sendButton)
        messageInputContainer.addContraintsWithFormat(hFormat: "", vFormat: "V:|[v0]|", views: sendButton)
        messageInputContainer.addContraintsWithFormat(hFormat: "H:|[v0]|", vFormat: "V:|[v0(1.5)]", views: topBorderInputView)
    }

    @objc func handleKeyboardWillAppear(notification: NSNotification){
        if let userinfo = notification.userInfo{
            let keyboardFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            bottomContraint.constant = -271.0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {self.view.layoutIfNeeded()}, completion: {
                (completed) in
                let indexPath = IndexPath(item: self.messages!.count-1 , section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
            })
        }
    }
    
    @objc func dismissKeyboard(){
        inputTextField.endEditing(true)
    }
    
    @objc func handleKeyboardWillDisappear(notification: NSNotification){
        bottomContraint.constant = 0
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
        })
    }
    
    //ep 4
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatCell
        
        // ep 5
        if let message = messages?[indexPath.item], let msgtext = message.text, let profPictName = message.toFriend?.profilePictString {
            
            cell.msgTextView.text = msgtext
            cell.profilePictureView.image = UIImage(named: profPictName)
            
            // string frame size of message
            let estimatedFrame = msgtext.frameSize(withConstrainedWidth: 275, withConstrainedHeight: 1000, font: UIFont.systemFont(ofSize: 18))
           
            // ep 6
            if !message.isSender{ // if message is from my friend
                // texts and bubbles' frames at cell
                cell.msgTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width+16, height: estimatedFrame.height+20)
                cell.textBubleView.frame = CGRect(x: 52, y: 0, width: estimatedFrame.width+16+16, height: estimatedFrame.height+20)
                cell.bubbleImageView.image = ChatCell.receiveBubbleChat
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.msgTextView.textColor = UIColor.black
                
            } else{ // if message is from me(the sender)
                // texts and bubbles' frames at cell
                cell.msgTextView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width+16, height: estimatedFrame.height+20)
                cell.textBubleView.frame = CGRect(x: view.frame.width-(estimatedFrame.width+28+20), y: 0, width: estimatedFrame.width+28+20, height: estimatedFrame.height+20)
                cell.bubbleImageView.image = ChatCell.senderBubbleChat
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.profilePictureView.isHidden = true
                cell.msgTextView.textColor = UIColor.white
            }
        }
        return cell
    }
    
    // ep 4
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // ep 5
        if let msgtext = messages?[indexPath.item].text {
            let estimatedFrame = msgtext.frameSize(withConstrainedWidth: 275, withConstrainedHeight: 1000, font: UIFont.systemFont(ofSize: 18))
            return CGSize(width: view.frame.width, height: estimatedFrame.height+20)
        }
        else {return CGSize(width: view.frame.width, height: 300)}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 0, 68, 0)
    }
    
}// end of class ChatLogCVC


// ep 4
class ChatCell : BaseCell {
    // ep 4
    let msgTextView : UITextView = {
        let textview = UITextView()
        textview.text = "Sample Text Message"
        textview.isEditable = false
        textview.isSelectable = false
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.backgroundColor = UIColor.clear
        return textview
    }()
    
    // ep 5
    let textBubleView : UIView = {
        let rectview = UIView()
        rectview.layer.cornerRadius = 7
        rectview.layer.masksToBounds = true
        return rectview
    }()
    
    let profilePictureView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let senderBubbleChat = UIImage(named: "bubble_sent")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21)).withRenderingMode(.alwaysTemplate)
    
    static let receiveBubbleChat = UIImage(named: "bubble_received")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21)).withRenderingMode(.alwaysTemplate)
    
    // ep 6
    let bubbleImageView : UIImageView = {
        let imgview = UIImageView()
        imgview.image = ChatCell.senderBubbleChat
        return imgview
    }()
    
    override func setupViewLayout() {
        addSubview(textBubleView)
        textBubleView.addSubview(bubbleImageView)
        textBubleView.addContraintsWithFormat(hFormat: "H:|[v0]|", vFormat: "V:|[v0]|", views: bubbleImageView)
        textBubleView.addSubview(msgTextView)
        
        addSubview(profilePictureView)
        addContraintsWithFormat(hFormat: "H:|-8-[v0(40)]", vFormat: "V:[v0(40)]|", views: profilePictureView)
    }
    
}

// ep 5
extension String {
    func frameHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func frameWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func frameSize(withConstrainedWidth width: CGFloat, withConstrainedHeight height: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                            attributes: [.font: font], context: nil)
        return boundingBox
    }
}

    

