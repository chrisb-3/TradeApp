//
//  Structs.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import Foundation
import MessageKit
import UIKit
import Foundation
import FirebaseAuth

struct AppUser {
    let userName: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}

struct Buttons {
    let backgroundImage: UIImage
    let buttonLabel: String
    let handler: (()-> Void)
    let action: Selector
}

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}

struct UserCell {
    let name: String
    let userEmail: String
}

struct ArticleButtons {
    let backgroundColor: UIColor
    let textColor: UIColor
    let buttonLabel: String
    let handler: (()-> Void)
    let action: Selector
}

struct StateButtons {
    let backgroundColor: UIColor
    let textColor: UIColor
    let buttonLabel: String
    let handler: (()-> Void)
    let action: Selector
}

public class AuthManager {
    
    static let shared = AuthManager()
    
    public func logOut(completion: (Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}

public enum DatabaseError: Error {
    case failedToFetch
    case failedToGetUserName
}

class Recommend {
    
    var selfId: String!
    var otherId: String!
    var imageId1: String!
    var imageId2: String!
    var poster_emial: String!
    
    init(selfId: String!, otherId: String!, dictionary1: Dictionary<String,AnyObject>, dictionary2: Dictionary<String,AnyObject>) {
        
        self.selfId = selfId
        self.otherId = otherId
        if let imageId1 = dictionary1["postImageNSUUID"] as? String {
            self.imageId1 = imageId1
        }
        if let imageId2 = dictionary2["postImageNSUUID"] as? String {
            self.imageId2 = imageId2
        }
        if let poster_emial = dictionary1["poster_emial"] as? String {
            self.poster_emial = poster_emial
        }
    }
}

class PostInfo {
    
    var articleType: String!
    var username: String!
    var aditionalInformation: String!
    var  city: String!
    var  color: String!
    var  country: String!
    var  productTitle: String!
    var  productState: String!
    var  size: String!
    var exchangeWish: String!
    var  gender: String!
    var postId: String!
    var postImageNSUUID: String!
    var poster_emial: String!
    
    init(postId: String!, dictionary: Dictionary<String,AnyObject>) {
        
        self.postId = postId
        
        if let aditionalInformation = dictionary["aditionalInformation"] as? String {
            self.aditionalInformation = aditionalInformation
        }
        if let city = dictionary["city"] as? String {
            self.city = city
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let gender = dictionary["gender"] as? String {
            self.gender = gender
        }
        if let articletype = dictionary["articletype"] as? String {
            self.articleType = articletype
        }
        if let color = dictionary["color"] as? String {
            self.color = color
        }
        if let country = dictionary["country"] as? String {
            self.country = country
        }
        if let productTitle = dictionary["productTitle"] as? String {
            self.productTitle = productTitle
        }
        if let productState = dictionary["productState"] as? String {
            self.productState = productState
        }
        if let size = dictionary["size"] as? String {
            self.size = size
        }
        if let postImageNSUUID = dictionary["postImageNSUUID"] as? String {
            self.postImageNSUUID = postImageNSUUID
        }
        if let poster_emial = dictionary["poster_emial"] as? String {
            self.poster_emial = poster_emial
        }
        if let exchangeWish = dictionary["exchangeWish"] as? String {
            self.exchangeWish = exchangeWish
        }
    }
}

class Convo {
    
    var id: String!
    var username: String!
    var otherUserEmail: String!
    var selfUserEmail: String!
    var otherImage: String!
    var selfImage: String!
    var latestMessage: String!
    
    init(id: String!, dictionary: Dictionary<String,AnyObject>) {
        
        self.id = id
        
        if let username = dictionary["other_username"] as? String {
            self.username = username
        }
        if let otherImage = dictionary["other_profile_image"] as? String {
            self.otherImage = otherImage
        }
        if let selfImage = dictionary["self_profile_image"] as? String {
            self.selfImage = selfImage
        }
        
        if let otherUserEmail = dictionary["other_user_email"] as? String {
            self.otherUserEmail = otherUserEmail
        }
        if let selfUserEmail = dictionary["sender_email"] as? String {
            self.selfUserEmail = selfUserEmail
        }
        if let latestMessage = dictionary["latest_Message"] as? String {
            self.latestMessage = latestMessage
        }
    }
}

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

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}
