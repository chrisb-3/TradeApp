//
//  AuthManager.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import Foundation
import FirebaseAuth
public class AuthManager {
    
    static let shared = AuthManager()
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            print(error)
            completion(false)
            return
        }
    }
}
