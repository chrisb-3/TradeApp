//
//  UserProfileSearchViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage

class UserProfileSearchViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    var posts = [PostInfo]()
    
    var maaail = String()
    
    var username = String()
    
    override func viewDidLoad() {
        print(maaail)
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        cofigureNavigationBar()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width-4)/3
        layout.itemSize = CGSize(width: size, height: size)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .systemBackground
        
        collectionView?.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        
        collectionView?.register(WishlistButtonCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WishlistButtonCollectionReusableView.identifier)
        
        collectionView?.register(PhotoPostCollectionViewCell.self, forCellWithReuseIdentifier: PhotoPostCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
            
        }
        view.addSubview(collectionView)
    }
    
    private func cofigureNavigationBar() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
                print("starting listing convos...")
        
        if maaail != safeEmail {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left.and.bubble.right"),
                                                        style: .done ,
                                                        target: self,
                                                        action: #selector(didTapChatButton))
        }
    }
    public func configure(username: String, email: String) {
        
        let profileTitleView = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        profileTitleView.textAlignment = .left
        profileTitleView.numberOfLines = 0
        profileTitleView.font = .systemFont(ofSize: 30, weight: .semibold)
        profileTitleView.text = username
        self.navigationItem.titleView = profileTitleView
        self.navigationController?.reloadInputViews()
        
        self.username = username

        Database.database().reference().child("Emails").child(email).child("posts").observe(.childAdded, with: { (snapshot) in
                
                print("snapshot: \(snapshot)")
                
                let postId = snapshot.key
                
                
                
                Database.database().reference().child("posts").child(postId).observeSingleEvent(of: .value, with: {snapshot in
                    print(snapshot)
                    guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                        return
                    }
                    
                    let post = PostInfo(postId: postId, dictionary: dictionary)
                    
                    self.posts.append(post)
                    
                    print("Post data: \(post)")
                    
                    self.collectionView?.reloadData()
                    
                })
            })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    
    @objc private func didTapChatButton() {
        let otherName = username
        let otherEmail = maaail
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)

        
        ///check if conversations child even exists
        DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child(otherEmail).observeSingleEvent(of: .value, with: { snapshot in
            let snap = snapshot.value as? String

            print("snapshot of convo child \(snap)")
            
            guard snap != nil else {
                /// the user does not jet have a folder with conversationss -> create one
                print("snap == nil")

                let newId = NSUUID().uuidString // generates a random id
                        // conversation doesn't exist yet -> create new convo
                print("conversation doesn't exist yet. New id: \(newId)")

                ///save the id in the convo folder of the curren t user and the other user so it can be recalled in future
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

                /// "all_convos" stores all conversation ids and under the ids all messages from a conversation
                DatabaseManager.database.child("all_convos").child("\(newId)").setValue(collection)

                DatabaseManager.database.child("Emails").child(otherEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let username = snapshot.value as? String else {
                        return
                    }
                    let otherImage = "images/\(otherEmail)_profile_picture.png"
                    let selfImage = "images/\(safeEmail)_profile_picture.png"
                    
                    let info : [String: String] = [
                        "other_user_email" : otherEmail,
                        "sender_email" : safeEmail,
                        "other_profile_image" : otherImage,
                        "self_profile_image" : selfImage,
                        "latest_Message": "",
                        "other_username": username
                    ]
                    ///folder containing information about sender/reciver and profile images
                    //folder selfEmail
                    DatabaseManager.database.child("conversation_information").child(newId).child(safeEmail).setValue(info)
                    //folder otherEmail
                    DatabaseManager.database.child("conversation_information").child(newId).child(otherEmail).setValue(info)
                    
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
                print("not null")
                
            DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child("\(otherEmail)").observeSingleEvent(of: .value, with: { snapshot in
                
                let id = snapshot.value
                print ("fetched id: \(id)")
                
                    let vc = ChatViewController(with: otherEmail, id: id as? String, otherName: otherName)
                vc.title = otherName
                vc.navigationItem.largeTitleDisplayMode = .never
                self.navigationController?.pushViewController(vc, animated: true)
                })
        })
    }
}

extension UserProfileSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // header 1&2 and posts
    }
    
    ///how many items in the views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0   }
        
        return posts.count
    }
    
    /// what cells are shown in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPostCollectionViewCell.identifier, for: indexPath) as! PhotoPostCollectionViewCell
        
        let postId = posts[indexPath.row].postImageNSUUID!
         
         DatabaseManager.database.child("posts").child(postId).child("Exchanged").observeSingleEvent(of: .value, with: { snapshot in
             guard let snap = snapshot.value as? String else {
                 return
             }
             print("snapshot \(snapshot)")

             if snap == "gone" {
                 print("Item is gone")
                 cell.postImageView.layer.opacity = 0.5
             }
             print("Item is open")

         })
        cell.post = posts[indexPath.row]
    
        return cell
    }
    
    /// what happens when a post photo is clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
//        let email = posts[indexPath.item].poster_emial!
        let email = maaail
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
            let username = snapshot.value as? String
            let vc = ClickOnePostViewController(with: safeEmail, username: username!)
            vc.post = self.posts[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    /// what supplementary view element are shown
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
        // WishlistButtonCollectionReusableView
        if indexPath.section == 1 {
            let wishButton = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WishlistButtonCollectionReusableView.identifier, for: indexPath) as! WishlistButtonCollectionReusableView
            wishButton.delegate = self
            return wishButton
            
        }
        else{
        //header view
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileHeaderCollectionReusableView

            header.emailString = maaail
//            header.email = maaail
        
//        header.delegate = self

        return header
    }
    }
    
    /// heights and widths of headerViews
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
         
            ///profile image
            return CGSize(width: collectionView.width, height: (collectionView.height)/4)
        }
        
        /// posts button with post label
        return CGSize(width: collectionView.width, height:
                        (collectionView.height)/8)
    }
    
    
}

extension UserProfileSearchViewController: WishlistButtonCollectionReusableViewDelegate{
    func DidTapWishlist(_header: WishlistButtonCollectionReusableView) {
        let vc = WishViewController()
            vc.configure(with: maaail)
            self.present(vc, animated: true)
    
    }
}
