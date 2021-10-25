//
//  ClickOnePostViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
class ClickOnePostViewController: UIViewController {
    
    var post: PostInfo?
    var user: String?
    public var allConvos = [Convo]()
    
    public let tableView: UITableView = {
        let tableView = UITableView ()
        tableView.register(headerTableViewCell.self, forCellReuseIdentifier: headerTableViewCell.identifier)
        tableView.register(postTableViewCell.self, forCellReuseIdentifier: postTableViewCell.identifier)
        tableView.register(chatTableViewCell.self, forCellReuseIdentifier: chatTableViewCell.identifier)
        tableView.register(descriptionTableViewCell.self, forCellReuseIdentifier: descriptionTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private var OtherEmailString: String
    private var OtherUsernameString: String
    
    init(with email: String, username: String){
        self.OtherEmailString = email
        self.OtherUsernameString = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClickOnePostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerTableViewCell.identifier) as! headerTableViewCell
            cell.postImg = post?.postImageNSUUID
            cell.delegate = self
            return cell
        }
        
        if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: postTableViewCell.identifier) as! postTableViewCell
            cell.postImg = post?.postImageNSUUID
            //
            guard let id = post?.postId as? String else {
                return UITableViewCell()
            }
            
            DatabaseManager.database.child("posts").child(id).child("Exchanged").observeSingleEvent(of: .value, with: { snapshot in
                guard let snap = snapshot.value as? String else {
                    return
                }
                print("snapshot \(snapshot)")
                
                if snap == "gone" {
                    print("Item is gone")
                    cell.postImage.layer.opacity = 0.5
                }
                print("Item is open")
                
            })
            return cell
        }
        if indexPath.row == 2 {
            
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return UITableViewCell()
            }
            let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
            let otherEmail = DatabaseManager.safeEmail(emailAdress: OtherEmailString)
            if otherEmail != safeEmail{
                let cell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCell.identifier) as! chatTableViewCell
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier) as! EmptyTableViewCell
                return cell
            }
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionTableViewCell.identifier) as! descriptionTableViewCell
            cell.postData = post
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        if indexPath.row == 1 {
            return view.width
        }
        if indexPath.row == 2 {
            return 70
        }
        if indexPath.row == 3 {
            return 500
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            guard let email = post?.poster_emial else {
                return
            }
            print("test if email is safe: \(email)")
            
            let vc = UserProfileSearchViewController()
            DatabaseManager.database.child("Emails").child(email).child("username").observeSingleEvent(of: .value, with: {snapshot in
                guard let name = snapshot.value as? String else{
                    return
                }
                vc.maaail = email
                vc.configure(username: name, email: email)
                
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
}

extension ClickOnePostViewController: headerTableViewCellDelegate {
    func didTapExchanged() {
        print("did tap exchanged")
        DatabaseManager.database.child("posts").child((post?.postImageNSUUID)!).child("Exchanged").setValue("gone")
    }
}

extension ClickOnePostViewController: chatTableViewCellDelegatge {
    func DidTapChat() {
        let otherName = OtherUsernameString
        let otherEmail = OtherEmailString
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        ///check if conversations child even exists
        DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child(otherEmail).observeSingleEvent(of: .value, with: { snapshot in
            let snap = snapshot.value as? String
            
            guard snap != nil else {
                /// the user does not jet have a folder with conversationss -> create one
                print("snap == nil")
                let newId = NSUUID().uuidString // generates a random id
                // conversation doesn't exist yet -> create new convo
                print("conversation doesn't exist yet. New id: \(newId)")
                
                ///save the id in the convo folder of the current user and the other user so it can be recalled in future
                DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child(otherEmail).setValue(newId)
                DatabaseManager.database.child("Emails").child(otherEmail).child("conversations").child(safeEmail).setValue(newId)
                
                let newMessage : [String: Any] = [
                    "type": "_",
                    "content": "_",
                    "username": otherName,
                    "otherUserEmail": otherEmail,
                    "currentUserEmail": safeEmail
                    
                ]
                
                let collection: [String: Any] = [
                    "messages": [
                        newMessage
                    ]
                ]
                
                /// "all_convos" stores all conversation id's and under the id's all messages from a conversation
                DatabaseManager.database.child("all_convos").child("\(newId)").setValue(collection)
                
                DatabaseManager.database.child("Emails").child(otherEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let OtherUsername = snapshot.value as? String else {
                        return
                    }
                    guard let selfUsername = UserDefaults.standard.value(forKey: "username") as? String else {
                        return
                    }
                    let otherImage = "images/\(otherEmail)_profile_picture.png"
                    let selfImage = "images/\(safeEmail)_profile_picture.png"
                    
                    let infoSelf : [String: String] = [
                        "other_user_email" : otherEmail,
                        "sender_email" : safeEmail,
                        "other_profile_image" : otherImage,
                        "self_profile_image" : selfImage,
                        "latest_Message": "",
                        "other_username": OtherUsername
                    ]
                    let infoOther : [String: String] = [
                        "other_user_email" : safeEmail,
                        "sender_email" : otherEmail,
                        "other_profile_image" : selfImage,
                        "self_profile_image" : otherImage,
                        "latest_Message": "",
                        "other_username": selfUsername
                    ]
                    
                    ///folder containing information about sender/reciver and profile images
                    //folder selfEmail
                    DatabaseManager.database.child("conversation_information").child(newId).child(safeEmail).setValue(infoSelf)
                    //folder otherEmail
                    DatabaseManager.database.child("conversation_information").child(newId).child(otherEmail).setValue(infoOther)
                    print("set conversation_information folder")
                })
                
                ///open new convo with newly created id
                let vc = ChatViewController(with: otherEmail, id: newId, otherName: otherName)
                vc.title = otherName
                vc.conversationId = newId
                vc.navigationItem.largeTitleDisplayMode = .never
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child("\(otherEmail)").observeSingleEvent(of: .value, with: { snapshot in
                let id = snapshot.value
                let vc = ChatViewController(with: otherEmail, id: id as? String, otherName: otherName)
                vc.title = otherName
                vc.navigationItem.largeTitleDisplayMode = .never
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
        })
        
    }
}
