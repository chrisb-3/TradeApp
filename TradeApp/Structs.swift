//
//  Structs.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import Foundation
import MessageKit
import UIKit



struct AppUser {
    let userName: String
    let emailAdress: String

    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    var profilePictureFileName: String {
        //images/christina-gmeil-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}

public enum DatabaseError: Error {
    case failedToFetch
    case failedToGetUserName
}

struct Post {
   let username: String
   let productTitle: String
    let inExchange: String
    let gender: String
   let city: String
   let country: String
   let size: String
   let color: String
   let productState: String
    let articelType: String
    let aditionalInfo: String
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

    var imageUrl: URL!
    
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
        if let imageUrl = dictionary["imageUrl"] as? URL {
            self.imageUrl = imageUrl
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
//    var imageUrl: URL!
    
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



struct User {
    let username: String
//    let bio: String
    let profilePhoto: UIImage//URL
    let gender: Gender
    let email: String
//    let postNumber: Int
    let points: Int
    let soltPosts: Int
    let userQuote: String
    let location: String
}

struct PostDescription {
    let productTitle: String
    let transactionType: String  //transactionType
//    let price: String?
    let city: String
    let articleType: String
    let gender: String
    let country: String
    let size: String
    let color: String
    let productState: String?
    let exchangeWish: String?
    let aditionalInformation: String?
    
}



enum Gender {
    case male, female, other, any
}
