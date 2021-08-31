//
//  ProfileViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage

public struct imagePost {
    let postId: String
    let dictionary: Dictionary<String, AnyObject>
}

public struct ProfilePosts {
    let productTitle: String
//    let transactionType: String
    let gender: String
    let articleType: String
//    let priceLabel: String?
    let city: String
    let country: String
    let size: String
    let color: String
    let productState: String?
    let exchangeWidh: String?
    let aditionalInformation: String?
    let imageUrl: URL
    let posterEmail: String
    
}

public struct TradeSellAll {
    
    let presentedCells: String
}

private var data = [TradeSellAll] ()

var UserEmail = UserDefaults.standard.value(forKey: "email") as! String

struct Type {
    let TransactionType: String
}

class ProfileViewController: UIViewController {
    
    
    private var collectionView: UICollectionView?
   
    var posts = [PostInfo]()

//    let noPostLabel: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "No Posts Yet"
//        return label
//    }()
    
    var mail = String()
    
//    private func validateAuth(){
//        if Auth.auth().currentUser == nil {
//            let vc = LoginViewController()
//            let nav = UINavigationController(rootViewController: vc) // user is not logged in, go to LogginViewcontroller
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true)
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        validateAuth()
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        validateAuth()
        data = []
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        fetchCurrentUserData()
        fetchPost()
        
//        view.addSubview(noPostLabel)
//        postImages = createPostArray()
//        buttons = crateEditorChat()
        
        
        
    
        
        //Profile Title
//        let profileTitleView = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
//        profileTitleView.textAlignment = .left
//        profileTitleView.numberOfLines = 0
////        profileTitleView.text = "Username"
//        profileTitleView.text = UserDefaults.standard.value(forKey: "username") as? String
//        profileTitleView.font = .systemFont(ofSize: 30, weight: .semibold)
//        navigationItem.titleView = profileTitleView
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width-4)/3
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .systemBackground
        
        /// Header with username, profilephoto, bio, post number, points
        collectionView?.register(SelfHeaderProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelfHeaderProfileCollectionReusableView.identifier)
        
        // Wishlist Button
        collectionView?.register(WishlistButtonCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WishlistButtonCollectionReusableView.identifier)
        
        // all posts
        collectionView?.register(PhotoPostCollectionViewCell.self, forCellWithReuseIdentifier: PhotoPostCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
            
        }
        
        
        view.addSubview(collectionView)
        

    }
    

    
    //MARK: -API
    
    //title of profileView with username
    func fetchCurrentUserData() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        print(email)
        
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: UserEmail)

        Database.database().reference().child("Emails").child(usersafeEmail).child("username").observeSingleEvent(of: .value) {(snapshot) in
            print(snapshot)

            guard let username = snapshot.value as? String else { // makes the snapshot a string
                return
            }
            UserDefaults.standard.setValue(username, forKey: "username")
            let name =  UserDefaults.standard.value(forKey: "username") as! String
            print ("The username \(name)")
//            self.navigationItem.title = username
            let profileTitleView = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            profileTitleView.textAlignment = .left
            profileTitleView.numberOfLines = 0
    //        profileTitleView.text = "Username"
            profileTitleView.text = UserDefaults.standard.value(forKey: "username") as? String
            profileTitleView.font = .systemFont(ofSize: 30, weight: .semibold)
            self.navigationItem.titleView = profileTitleView
            self.navigationController?.reloadInputViews()
            print("set unsername and email")
        }
    
    }
    

    
    func fetchPost() {
    
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
//
        
        Database.database().reference().child("Emails").child(safeEmail).child("posts").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            let postId = snapshot.key
            
            DatabaseManager.database.child("posts").child(postId).observeSingleEvent(of: .value, with: {snapshot in
                print(snapshot)
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    return
                }
//                if dictionary.isEmpty {
//                    self.collectionView?.isHidden = true
//                    self.noPostLabel.isHidden = false
//                    print("no posts")
//                }
                
//                let post = imagePost(postId: postId, dictionary: dictionary)
                let post = PostInfo(postId: postId, dictionary: dictionary)
                
                self.posts.append(post)
                
                print("Post data\(post)")
                
                self.collectionView?.reloadData()
                
            })
        })
    }
 

    private func configureNavigationBar() {
        let Settings = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done ,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
        let NewPostButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                                            style: .done ,
                                                            target: self,
                                                            action: #selector(didTapAddPostButton))
//        let Scanner = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"),
//                                                            style: .done ,
//                                                            target: self,
//                                                            action: #selector(didTapScannButton))
        navigationItem.rightBarButtonItems = [Settings, NewPostButton]
//                                              , Scanner]
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
//        noPostLabel.frame = CGRect(x: view.width/2,
//                                   y: 120,
//                                   width: 30,
//                                   height: 30)
        
    }
    
    @objc private func didTapEditButton() {
        
    }
    
//    @objc private func didTapChatButton() {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
////        DatabaseManager.database.child(emailString).child("username").observeSingleEvent(of: .value, with: { snapshot in
////
////            let selfUsername = snapshot.value
////        })
//
//        DatabaseManager.database.child(safeEmail).child("conversations").child("\(emailString)").observeSingleEvent(of: .value, with: { snapshot in
//
//            let id = snapshot.value as? String
//            print ("fetched id: \(id)")
//
//
//            if id == "nil" {
//                let newId = NSUUID().uuidString // generates a random id
//                        // conversation doesn't exist yet -> create new convo
//
//                DatabaseManager.database.child(safeEmail).child("conversations").child(self.emailString).setValue(newId)
//                DatabaseManager.database.child(self.emailString).child("conversations").child(safeEmail).setValue(newId)
//
//
//
////                let conversationData : [String: String] = [
////                    "id": newId,
////                    "username": selfUsername,
////                    "otherUserEmail": emailString,
////                    "currentUserEmail": safeEmail,
////                    "latestMessage": message
////                ]
//
////                let newConvo = Convo(id: newId, dictionary: conversationData)
////
////
////                self.allconvos.appen
////                var allConvos =
//
//                let vc = ChatViewController(with: self.emailString, id: newId)
//                vc.title = self.usernameString
//                vc.navigationItem.largeTitleDisplayMode = .never
//                self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//                    }
//            let vc = ChatViewController(with: self.emailString, id: id)
//            vc.title = self.usernameString
//            vc.navigationItem.largeTitleDisplayMode = .never
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//        })
//
//    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapAddPostButton() {
        let vc = ProductDescriptionViewController()
        vc.title = "choose"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
//    @objc private func didTapScannButton() {
//
//        presentPhotoActionSheetProfile()
//
//
//
//   }

    
    
//    @objc func didTapuserDescriptionButtonP() {
//   }
//
//    @objc func didTapbadgeButtonP() {
//
//   }
//    @objc func didTapsoldItemsButtonP() {
//
//    }
//
//    @objc func didTapeditProfileButtonP() {
//
//    }
//    @objc func didTapStartComversationP() {
//
//    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // header 1&2 and posts
    }
    
    ///how many items in the views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0       }
        
//        return posts.count //posts are appended to [Post] and the count is loaded here
//        return postImages.count
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
        
//        cell.configure(with: "green")
//        let model = postImages[indexPath.row]
//        cell.configure(with: model)
//        cell.configurePost(with: "green")
//        cell.post = postImages[indexPath.item]
        
//        let imageUrl = posts.description[indexPath.item]["imageUrl"]
//        cell.sd_imageURL = posts.description[indexPath.item]["imageUrl"]
        cell.post = posts[indexPath.row]
    
        return cell
    }
    
    /// what happens when a post photo is clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let email = posts[indexPath.item].poster_emial!
        
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
        
//        if indexPath.section != 1 {
//            let editOrChat = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Other_ProfileHeaderCollectionReusableView.identifier, for: indexPath)
////            let editOrChatButton = buttons[indexPath.row]
//            return editOrChat
//        }
//        if indexPath.section != 1 {
//            let editOrChat = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath)
////            let editOrChatButton = buttons[indexPath.row]
//            return editOrChat
//        }
//
        // WishlistButtonCollectionReusableView
        if indexPath.section == 1 {
            let wishButton = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WishlistButtonCollectionReusableView.identifier, for: indexPath) as! WishlistButtonCollectionReusableView
            wishButton.delegate = self
            
            return wishButton
            
        }
        
        //header view
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelfHeaderProfileCollectionReusableView.identifier, for: indexPath) as! SelfHeaderProfileCollectionReusableView
//        header.delegate = self
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return UICollectionReusableView(
//        }
//        let email = mail
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//        header.emailString = safeEmail
        

        return header
        
    }
    
    /// heights and widths of headerViews
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
//            return CGSize(width: collectionView.width, height: (collectionView.height)/2.8 )
            return CGSize(width: collectionView.width, height: (collectionView.height)/4)
        }
        
//        return CGSize(width: collectionView.width, height: (collectionView.height)/2.5)
        return CGSize(width: collectionView.width, height: (collectionView.height)/8)

    }
    
    
}


extension ProfileViewController: WishlistButtonCollectionReusableViewDelegate{
  
    
    func DidTapPostsButton(_header: WishlistButtonCollectionReusableView) {
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top , animated: true)
    }
    
    func DidTapWishlist(_header: WishlistButtonCollectionReusableView) {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        let vc = WishViewController()
        vc.configure(with: safeEmail)
        present(vc, animated: true)
        
        
    }
    

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func DidTapEditText(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//
//
//    func DidTapUserBadgeButton(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapSoldPostsButton(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapStartChatButton(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapEditProfileButton(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapUserProfileImage(_ header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapUserDescriptionButton(_header: Other_ProfileHeaderCollectionReusableView) {
//
//    }
   
    
    
//    func presentPhotoActionSheetProfile() {
//        let actionSheet = UIAlertController(title: "Profile Picture", message: "select a profile Image", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Cancel",
//                                            style: .cancel,
//                                            handler: nil))
//        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
//                                            style: .default,
//                                            handler: { [weak self] _ in
//                                                self?.choosePhoto()
//                                            }))
//        present(actionSheet, animated: true)
//    }
    
//    func choosePhoto() {
//        UIImagePickerController().sourceType = .photoLibrary
//        present(UIImagePickerController(), animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let url =  info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            print(url)
//           uploadToCloud(fileURL: url)
//        }
//
//        let url =  info[UIImagePickerController.InfoKey.imageURL] as! URL
//        uploadToCloud(fileURL: url)
//        UIImagePickerController().dismiss(animated: true, completion: nil)
//
//    }
  
    
//    func uploadToCloud(fileURL: URL) {
//        let storage = Storage.storage()
//        let data = Data()
//        let starageRef = storage.reference()
////        let localFile = fileURL
//
//        let photoRef = starageRef.child("images")
//
//        let uploadTask = photoRef.putData(data, metadata: nil) {(metadata, error) in
//            guard let metadata = metadata else {
//                return
//            }
//            let size = metadata.size
//              // You can also access to download URL after upload.
//              photoRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                  // an error occurred!
//                  return
//                }
//                }
//        }
//
//    }
    
}

