//
//  ChatViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind

}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_Text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_prewiew"
        case .custom(_):
            return "custom"
        }
    }
}

//struct Media: MediaItem {
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//}

struct Sender: SenderType {
    
   public var photoURL: String
   public var senderId: String
   public var displayName: String
}



class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
     let otherUserEmail: String
    var conversationId: String?
    let otherName: String
//    public var isNewConversation = false

    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?

    
    private var messages = [Message]()
    
    private var selfSender: Sender? { // Sender is optional because if email doesn't exist in cash in UserDefaults, then don't return sender
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
        
    }
    
    
    
    init(with email: String, id: String?, otherName: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        self.otherName = otherName!
        super.init(nibName: nil, bundle: nil)
//        if let conversationId = conversationId {
//            listenForMessages(id: conversationId, shouldScrollToBottom: true)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
    }
    
    private func setupInputButton() {
//        let button = InputBarButtonItem()
//        button.setSize(CGSize(width: 35, height: 35), animated: false)
//        button.setImage(UIImage(systemName: "camera"), for: .normal)
//        button.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
////        button.onTouchUpInside({ [weak self] _ in
////
//////            self?.presentInputActionSheet()
////
////        })
//        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: true)
//        messageInputBar.setStackViewItems([button], forStack: .left, animated: true)
    }
    
//    private func presentInputActionSheet() {
//
//    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {

        DatabaseManager.shared.gettAllMessages(with: id, completion: { [weak self] result in

            switch result {
            case .success(let messages):
                print("success in getting messages: \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
//
                self?.messages = messages
//
                DispatchQueue.main.async { // because it is a UI opperation it should occure on the main que
                    self?.messagesCollectionView.reloadDataAndKeepOffset() // messages show at bottom. The user scrolls up (not down)
// 
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                }
//
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
    
    @objc func didTapCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) { // Function that runs when send is clicked. text is the text typed in by the user.
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender
//              let messageId = createMessageId()
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
        
//        //send Message
        let newConversationId =  message.messageId
        conversationId = newConversationId
        listenForMessages(id: newConversationId, shouldScrollToBottom: true)
        messageInputBar.inputTextView.text = nil
        
//        if isNewConversation {
//            //create convo in database
//
//            let message = Message(sender: selfSender,
//                                  messageId: messageId,
//                                  sentDate: Date(),
//                                  kind: .text(text))
//
//
//            DatabaseManager.shared.newConvo(with: otherUserEmail, username: self.title ?? "User", firstMessage: message, completion: { [weak self] success in
//
////            (with: otherUserEmail, otherUserName: self.title ?? "User", firstMessage: message, completion: { [weak self] success in // self.title ?? makes the title of the chat the other users name
//                if success {
//                    print("message sent")
//                    self?.isNewConversation = false // the conversation exists
//                }
//                else {
//                    print("failed to send")
//
//                }
//            })
//        }
//        else { // existing conversation
//            guard let conversationId = conversationId, let username = self.title else {
//                return
//            }
        guard let username = self.title else {
                        return
                    }
            // append to existing conversation data
        DatabaseManager.shared.sendMessage(to: id, otherUserEmail: otherUserEmail , OtherUsername: username, otherEmail: otherUserEmail, newMessage: message, completion: {  [weak self] success in
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
             
            
//        }
    }
    

//    private func createMessageId() -> String? { // generates random message id
//        // date, otherUserEmail, senderEmail, randomInt
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String // S in Self is capital because it is static
//                else {
//            return nil
//        }
//
//        let currentUserEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//              let dateString = Self.dateFormatter.string(from: Date())
//
//        let safeCurrentEmail = DatabaseManager.safeEmail(emailAdress: currentUserEmail)
//
//
//        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
//
//        print("created message id: \(newIdentifier)")
//
//        return newIdentifier
//    }
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
                
//            DatabaseManager.database.child("conversation_information").child(conversationId!).child(safeEmail).child("self_profile_image").observeSingleEvent(of: .value, with: { snapshot in
//
//                guard let selfPath = snapshot.value as? String else {
//                    return
//                }
                
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
                
//            })
            }

        }
        else {
            if let otherUsrePHotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUsrePHotoURL, completed: nil)
            }
            else {
//            DatabaseManager.database.child("conversation_information").child(conversationId!).child(otherUserEmail).child("other_profile_image").observeSingleEvent(of: .value, with: { snapshot in
//
//                guard let otherPath = snapshot.value as? String else {
//                    return
//                }
//                print("profile image othr user: \(otherPath)")

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
                
//            })
            }
            
        }
        
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let messageId = createMessageId(),
//            let conversationId = conversationId,
//            let name = self.title,
//            let selfSender = selfSender else {
//                return
//        }
//
//        let image = info[.editedImage] as? UIImage
////
//        let imageData =  image!.pngData()
//
//            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
//
//            // Upload image
//        DatabaseManager.shared.uploadMessagePhoto(with: imageData!, fileName: fileName, completion: { [weak self] result in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                switch result {
//                case .success(let urlString):
//                    // Ready to send message
//                    print("Uploaded Message Photo: \(urlString)")
//
//                    guard let url = URL(string: urlString),
//                        let placeholder = UIImage(systemName: "plus") else {
//                            return
//                    }
//
//                    let media = Media(url: url,
//                                      image: nil,
//                                      placeholderImage: placeholder,
//                                      size: .zero)
//
//                    let message = Message(sender: selfSender,
//                                          messageId: messageId,
//                                          sentDate: Date(),
//                                          kind: .photo(media))
//
//                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, username: name, newMessage: message, completion: { success in
//
//                        if success {
//                            print("sent photo message")
//                        }
//                        else {
//                            print("failed to send photo message")
//                        }
//
//                    })
//
//                case .failure(let error):
//                    print("message photo upload error: \(error)")
//                }
//            })
//        }
       
        
    }



//extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = image.pngData(),
//              let messageId = createMessageId(),
//              let conversationId = conversationId,
//        let username = self.title ,
//        let sender = selfSender else {
//            return
//        }
//
//        let fileName = "photo_message_"+messageId
//
//
//
//        StorageManager.shared.uploaMessagePhoto(with: imageData, fileName: fileName, completion: { result in
//            switch result {
//            case .success(let urlString):
//            //send message
//            print("uploaded photo as message: \(urlString)")
//                guard let url = URL(string: urlString), let placeholder = UIImage(systemName: "plus") else { //placeholder image can be any random image.
//                    return
//                }
//
//                let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
//
//                let message = Message(sender: sender,
//                                      messageId: messageId,
//                                      sentDate: Date(),
//                                      kind: .photo(media))
//
//                DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: self.otherUserEmail, username: username, newMessage: message) { success in
//                    if success {
//                        print("sent photo message")
//                    }
//                    else {
//                        print("failed to sent photo")
//                    }
//                }
//            case .failure(let error):
//            print("message photo upload error: \(error)")
//
//            }
//
//        } )
//
//    }
//
//}

//extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let messageId = createMessageId(),
//            let conversationId = conversationId,
//            let name = self.title,
//            let selfSender = selfSender else {
//                return
//        }
//
//        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
//            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
//
//            // Upload image
//            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                switch result {
//                case .success(let urlString):
//                    // Ready to send message
//                    print("Uploaded Message Photo: \(urlString)")
//
//                    guard let url = URL(string: urlString),
//                        let placeholder = UIImage(systemName: "plus") else {
//                            return
//                    }
//
//                    let media = Media(url: url,
//                                      image: nil,
//                                      placeholderImage: placeholder,
//                                      size: .zero)
//
//                    let message = Message(sender: selfSender,
//                                          messageId: messageId,
//                                          sentDate: Date(),
//                                          kind: .photo(media))
//
//                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
//
//                        if success {
//                            print("sent photo message")
//                        }
//                        else {
//                            print("failed to send photo message")
//                        }
//
//                    })
//
//                case .failure(let error):
//                    print("message photo upload error: \(error)")
//                }
//            })
//        }
//        else if let videoUrl = info[.mediaURL] as? URL {
//            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
//
//            // Upload Video
//            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                switch result {
//                case .success(let urlString):
//                    // Ready to send message
//                    print("Uploaded Message Video: \(urlString)")
//
//                    guard let url = URL(string: urlString),
//                        let placeholder = UIImage(systemName: "plus") else {
//                            return
//                    }
//
//                    let media = Media(url: url,
//                                      image: nil,
//                                      placeholderImage: placeholder,
//                                      size: .zero)
//
//                    let message = Message(sender: selfSender,
//                                          messageId: messageId,
//                                          sentDate: Date(),
//                                          kind: .video(media))
//
//                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
//
//                        if success {
//                            print("sent photo message")
//                        }
//                        else {
//                            print("failed to send photo message")
//                        }
//
//                    })
//
//                case .failure(let error):
//                    print("message photo upload error: \(error)")
//                }
//            })
//        }
//    }
//
//}
