//
//  ChatViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    let otherUserEmail: String
    let otherName: String
    var conversationId: String?
    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?
    private var messages = [Message]()
    
    private var selfSender: Sender? { // Sender is optional because if email doesn't exist in UserDefaults, then don't return sender
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "")
    }
    
    init(with email: String, id: String?, otherName: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        self.otherName = otherName!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        
        DatabaseManager.shared.gettAllMessages(with: id, completion: { [weak self] result in
            
            switch result {
            case .success(let messages):
                print("success in getting messages: \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async { // because it is a UI opperation it should occure on the main que
                    self?.messagesCollectionView.reloadDataAndKeepOffset() // messages show at bottom. The user scrolls up (not down)
                    
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                }
            case .failure(let error):
                print("failed to get messages \(error)")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder() // presentts keyboard
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) { // Function that runs when send is clicked. text is the text typed in by the user.
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender
        else {
            return
        }
        print("Sending: \(text)")
        
        guard let id = conversationId else {
            return
        }
        
        let message = Message(sender: selfSender,
                              messageId: id,
                              sentDate: Date(),
                              kind: .text(text))
        //send Message
        let newConversationId =  message.messageId
        conversationId = newConversationId
        listenForMessages(id: newConversationId, shouldScrollToBottom: true)
        messageInputBar.inputTextView.text = nil
        
        guard let username = self.title else {
            return
        }
        // append to existing conversation data
        DatabaseManager.shared.sendMessage(to: id, otherUserEmail: otherUserEmail , OtherUsername: username, newMessage: message, completion: {  [weak self] success in
            if success {
                self?.messageInputBar.inputTextView.text = nil
                print("message sent")
                
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                
                let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
                guard let otherMail = self!.otherUserEmail as? String else {
                    return
                }
                
                DatabaseManager.database.child("conversation_information").child(id).child(safeEmail).child("latest_Message").setValue(text)
                
                DatabaseManager.database.child("conversation_information").child(id).child(otherMail).child("latest_Message").setValue(text)
            }
            else {
                print("failed to send")
            }
        })
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            //self message
            return .white
        }
        return .white
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            //self message
            return .systemRed
        }
        return .systemPink
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            if let currentUserImageURL = self.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
            else {
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
                let selfPath = "images/\(safeEmail)_profile_picture.png"
                print("profile image self: \(selfPath)")
                
                StorageManager.shared.downloadURL(for: selfPath, completion: { result in
                    switch result {
                    case .success(let url):
                        self.senderPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil
                            )}
                    case .failure(let error):
                        print("\(error)")
                    }
                })
            }
        }
        else {
            if let otherUsrePHotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUsrePHotoURL, completed: nil)
            }
            else {
                let otherPath = "images/\(otherUserEmail)_profile_picture.png"
                StorageManager.shared.downloadURL(for: otherPath, completion: { result in
                    switch result {
                    case .success(let url):
                        self.otherUserPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil
                            )}
                    case .failure(let error):
                        print("\(error)")
                    }
                })
            }
        }
    }
}

