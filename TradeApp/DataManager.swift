//
//  DataManager.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import Foundation
import FirebaseDatabase
import Firebase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    static let database = Database.database().reference()
    
    static func safeEmail(emailAdress: String ) -> String {
        var safeEmail = emailAdress.replacingOccurrences(of: "." , with: "_")
         safeEmail = safeEmail.replacingOccurrences(of: "@" , with: "_" )
        return safeEmail
    }

}
extension DatabaseManager {
    public func getAllUsers(completion: @escaping (Result<[[String: String]],Error>) -> Void) {
        DatabaseManager.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value)) 
        })
    }
    
    
    private func finishCreatingConversation(username: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch firstMessage.kind {
        
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "username": username
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        print("adding conversation: \(conversationID)")
        
        DatabaseManager.database.child("\(conversationID)").setValue( value, withCompletionBlock: { error, _ in
            guard error == nil else {
               completion(false)
                return
            }
            completion(true)
        } )
        
    }
    public func gettAllMessages( with id: String, completion: @escaping (Result<[Message ], Error>) -> Void) {
        
        DatabaseManager.database.child("all_convos").child("\(id)").child("messages").observe( .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap({ dictionary in
                guard
//                    let username = dictionary["username"] as? String,
                    //                      let messagId = dictionary["id"] as? String,
                    let otherEmail = dictionary["otherUserEmail"] as? String,
                    let content = dictionary["content"] as? String,
                    let senderEmail = dictionary["sender_email"] as? String,
                    let otherUsername = dictionary["username"] as? String,
                    //                      let dateString = dictionary["date"] as? String,
                    let type = dictionary["type"] as? String
                //                      let isRead = dictionary["is_read"] as? Bool,
                //                      let date = ChatViewController.dateFormatter.date(from: dateString)
                else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: otherUsername)
                
                return Message(sender: sender,
                               messageId: id,
                               sentDate: Date(),
                               kind: .text(content))
            })
            completion(.success(messages))
        } )
    }

    public func sendMessage(to conversationId: String, otherUserEmail: String, OtherUsername: String, otherEmail: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages in convId
        //update sender latest message
        //update reciver latest message
                
        DatabaseManager.database.child("all_convos").child(conversationId).child("messages").observeSingleEvent(of: .value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: String]] else {
//                return
//            }
//            guard let strongSelf = self else {
//                return
//            }
            print("conversation: \(snapshot)")
//            var currentMessage = snapshot.value as! [[String: Any]]
            guard var currentMessage = snapshot.value as? [[String: Any]] else {
                print("1")
                completion(false)
                return
            }
            
//            let messageDate = newMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
//            case .photo(let mediaItem):
////                if let targetUrlString = mediaItem.url?.absoluteString{
////                message = targetUrlString
////                }
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
//            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//                completion(false)
//                print("3")
//                return
//            }
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                print("2")
                return
            }
            
            let currentEmail = DatabaseManager.safeEmail(emailAdress: myEmail)
            
            let collectionMessage: [String: Any] = [
//                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
//                "date": dateString,
                "username": OtherUsername,
                "otherUserEmail": otherEmail,
                "sender_email": currentEmail,
//                "is_read": false,
                
            ]
            
//            let messageValue: [String: Any] = [
//                "messages": [
//                    collectionMessage
//                ]
//            ]
            currentMessage.append(collectionMessage)
            
            DatabaseManager.database.child("all_convos").child("\(conversationId)").child("messages").setValue(currentMessage) { error , _ in
                guard error == nil else {
                    completion(false)
                    print("4")
                    print("error")
                    return
                }
                
                
                
                completion(true)
                print("success")
            }
            
        })
       
    }
    // check if a user with this emial already is registerd
    public func userExists(with email: String,
                           completion: @escaping (Bool) -> Void) {  // will return true if user email does not exist. If returns true-> cant't use email

        var safeEmail = email.replacingOccurrences(of: "." , with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@" , with: "_" )
        
        DatabaseManager.database.child("Emails").child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else { // in this snapshot, if value is a string then assign it
                
                completion(false) // email doesn't exist yet. -> Create account
                return
            }
            
            completion(true) // email already exists
        })
    }

    public func addUserDataToFirebase(with user: AppUser, completion: @escaping (Bool) -> Void ) {
        
        DatabaseManager.database.child("Emails").child(user.safeEmail).setValue([
            "username": user.userName,
//            "profile_data":  [
//                "posts": "2",
//                "points": "2",
//                "sold": "3"
//            ]
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to wright to database")
                completion(false)
                return
            }
                

            DatabaseManager.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {

                    //append to users dictionary
                    let newElement = [
                        "username": user.userName,
                        "email": user.safeEmail
//                        "profile_image":
                    ]
                    userCollection.append(newElement)

                    DatabaseManager.database.child("users").setValue(userCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }

                //create aray/dictionary
                else {
                    
                    let newCollecton: [[String: String]] =
                    [
                        [
                            "username": user.userName,
                            "email": user.safeEmail
//                            "porfileImage":
                        ]
                    ]

                    DatabaseManager.database.child("users").setValue(newCollecton, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)

                    })
                }
            })
            
            
        })
        
        DatabaseManager.database.child("usernames").child(user.userName).setValue([
                                                "email": user.safeEmail
        ]
        )
    }
    
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UpladPictureCompletion = (Result <String, Error> ) -> Void
    
    /// Upload pictures to firebase  stoage and return completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UpladPictureCompletion) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    
    public func uploadProfilePostImage(with data: Data, fileName: String, completion: @escaping UpladPictureCompletion) {
        
        storage.child("post_images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("post_images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
                
//                Database.database().reference().child(safeEmail).child("posts").setValue("\(urlString)")
                
                completion(.success(urlString))
            })
        })
        
    }
    
    /// Upload image in conversation
    public func uploaMessagePhoto (with data: Data, fileName: String, completion: @escaping UpladPictureCompletion) {
        
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("message_images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
                             
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
                    }
                    completion(.success(url))
            
        })
    }
}


public typealias UpladPictureCompletion = (Result <String, Error> ) -> Void


public func storeWishlistToFirebase(with list: String) {
    
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
        return
    }
    let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
    
    DatabaseManager.database.child("Emails").child(safeEmail).child("Wishlist").setValue(list)
}


public func storePostDataToFirebase(with data: Data,
                                    
                                    fileName: String,
                                    poster: String,
                                    postImageNSUUID: String,
                                    articleType: String,
                                    exchangeWish: String,
                                    productTitle: String,
                                    gender: String,
                                    city: String,
                                    country: String,
                                    size: String,
                                    color: String,
                                    productState: String,
                                    aditionalInformation: String,
                                    
                                    completion: @escaping UpladPictureCompletion) {
    
    Storage.storage().reference().child("post_images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
        guard error == nil else {
            //failed
            print("failed to upload data to firebase for picture")
            completion(.failure(StorageErrors.failedToUpload))
            return
        }
        Storage.storage().reference().child("post_images/\(fileName)").downloadURL(completion: {url, error in
            guard let url = url else {
                print("failed to get download url")
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            
            let urlString = url.absoluteString
            print("download url returned: \(urlString)")
            
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
            
            let post : [String: String] = [
                "imageUrl" : urlString,
                "postImageNSUUID" : postImageNSUUID,
                "articleType" : articleType,
                "productTitle" : productTitle,
                "gender": gender,
                "exchangeWish" : exchangeWish,
                "city" : city,
                "country" : country,
                "size" : size,
                "color" : color,
                "productState" : productState,
                "aditionalInformation" : aditionalInformation,
                "poster_emial" : safeEmail
            ]
            DatabaseManager.database.child("posts").child(postImageNSUUID).setValue(post)
            
            Database.database().reference().child("Emails").child("\(safeEmail)").child("posts").child("\(postImageNSUUID)").setValue("\(postImageNSUUID)")
            
            
            
            Database.database().reference().child("all_posts").child("\(postImageNSUUID)").setValue("\(postImageNSUUID)")
            
            
            /// colors
            if color == "Blue" {
                DatabaseManager.database.child("Search").child("color").child("Blue").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if color == "Pink" {
                DatabaseManager.database.child("Search").child("color").child("Pink").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            
            if color == "Yellow" {
                DatabaseManager.database.child("Search").child("color").child("Yellow").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            if color == "Orange" {
                DatabaseManager.database.child("Search").child("color").child("Orange").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            if color == "Red" {
                DatabaseManager.database.child("Search").child("color").child("Red").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            if color == "Purple" {
                DatabaseManager.database.child("Search").child("color").child("Purple").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            
            if color == "Green" {
                DatabaseManager.database.child("Search").child("color").child("Green").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            if color == "Brown" {
                DatabaseManager.database.child("Search").child("color").child("Brown").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            if color == "White" {
                DatabaseManager.database.child("Search").child("color").child("White").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }
            
            if color == "Black" {
                DatabaseManager.database.child("Search").child("color").child("Black").child(postImageNSUUID).setValue(postImageNSUUID)
                
            }

            ///Item states
            if  productState == "good" {
                DatabaseManager.database.child("Search").child("Item_state").child("Good").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  productState == "bad" {
                DatabaseManager.database.child("Search").child("Item_state").child("Bad").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  productState == "new" {
                DatabaseManager.database.child("Search").child("Item_state").child("New").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  productState == "old" {
                DatabaseManager.database.child("Search").child("Item_state").child("Old").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  productState == "used" {
                DatabaseManager.database.child("Search").child("Item_state").child("Used").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  productState == "very good shape" {
                DatabaseManager.database.child("Search").child("Item_state").child("very_good_shape").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            
            
            
            /// garments
            if  articleType == "jeans" {
                DatabaseManager.database.child("Search").child("Garments").child("jeans").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "t-shirt" {
                DatabaseManager.database.child("Search").child("Garments").child("t-shirt").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "coat" {
                DatabaseManager.database.child("Search").child("Garments").child("coat").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "shirt" {
                DatabaseManager.database.child("Search").child("Garments").child("shirt").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "dress" {
                DatabaseManager.database.child("Search").child("Garments").child("dress").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "skirt" {
                DatabaseManager.database.child("Search").child("Garments").child("skirt").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "jacket" {
                DatabaseManager.database.child("Search").child("Garments").child("jacket").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "pants" {
                DatabaseManager.database.child("Search").child("Garments").child("pants").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "accessories" {
                DatabaseManager.database.child("Search").child("Garments").child("accessories").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "shoes" {
                DatabaseManager.database.child("Search").child("Garments").child("shoes").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  articleType == "other" {
                DatabaseManager.database.child("Search").child("Garments").child("other").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            
            
            
            /// gender
            if  gender == "Male" {
                DatabaseManager.database.child("Search").child("gender").child("Male").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  gender == "Female" {
                DatabaseManager.database.child("Search").child("gender").child("Female").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  gender == "Other" {
                DatabaseManager.database.child("Search").child("gender").child("Other").child(postImageNSUUID).setValue(postImageNSUUID)
            }
            if  gender == "Any" {
                DatabaseManager.database.child("Search").child("gender").child("Any").child(postImageNSUUID).setValue(postImageNSUUID)
            }
        
        })
        })
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
        return
    }
    let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
    
    DatabaseManager.database.child("Emails").child(safeEmail).child("wishes").child(exchangeWish).setValue(postImageNSUUID)
    DatabaseManager.database.child("Emails").child(safeEmail).child("has").child(articleType).setValue(postImageNSUUID)
    
    }
        
            public func createNewConvo( otherEmail: String,
                                       myEmail: String) {
                let id1 = "\(myEmail)"+"\(otherEmail)"
                let id2 = "\(otherEmail)"+"\(myEmail)"
                
                DatabaseManager.database.child("Emails").child(myEmail).child("conversations").child(id1).setValue(id1)
                DatabaseManager.database.child("Emails").child(myEmail).child("conversations").child(id2).setValue(id2)
                
                DatabaseManager.database.child("Emails").child(otherEmail).child("conversations").child(id1).setValue(id1)
                DatabaseManager.database.child("Emails").child(otherEmail).child("conversations").child(id2).setValue(id2)
            }



            public enum StorageErrors: Error {
                case failedToUpload
                case failedToGetDownloadUrl
            }
        
