////
////  ProfileViewController.swift
////  Traide'oro
////
////  Created by Christina Braun on 28.08.21.

import UIKit
import Firebase

var UserEmail = UserDefaults.standard.value(forKey: "email") as! String

class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    var posts = [PostInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Called viewDidLoad")
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        fetchCurrentUserData()
        fetchPost()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width-4)/3
        layout.itemSize = CGSize(width: size, height: size)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .systemBackground
        
        // Header with username, profilephoto, bio, post number, points
        collectionView?.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        
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
    
    ///title of profileView with username
    func fetchCurrentUserData() {
        
        guard let email = UserDefaults.standard.object(forKey: "email") as? String else {
            return
        }
        
        print(email)
        
        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: UserEmail)
        
        Database.database().reference().child("Emails").child(usersafeEmail).child("username").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            
            guard let username = snapshot.value as? String else {
                return
            }
            UserDefaults.standard.setValue(username, forKey: "username")
            let name =  UserDefaults.standard.value(forKey: "username") as! String
            print ("The username \(name)")
            DispatchQueue.main.async {
                
                let profileTitleView = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
                profileTitleView.textAlignment = .left
                profileTitleView.numberOfLines = 0
                profileTitleView.text = UserDefaults.standard.value(forKey: "username") as? String
                profileTitleView.font = .systemFont(ofSize: 30, weight: .semibold)
                self.navigationItem.titleView = profileTitleView
                self.navigationController?.reloadInputViews()
                print("set usernames and email")
            }
        }
        )                                                                                             }
    func fetchPost() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        Database.database().reference().child("Emails").child(safeEmail).child("posts").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            let postId = snapshot.key
            
            DatabaseManager.database.child("posts").child(postId).observeSingleEvent(of: .value, with: {snapshot in
                print(snapshot)
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    return
                }
                
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
        navigationItem.rightBarButtonItems = [Settings, NewPostButton]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
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
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // header 1&2 and posts
    }
    
    ///how many items in the views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0       }
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
        
        // WishlistButtonCollectionReusableView
        if indexPath.section == 1 {
            let wishButton = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WishlistButtonCollectionReusableView.identifier, for: indexPath) as! WishlistButtonCollectionReusableView
            wishButton.delegate = self
            return wishButton
        }
        
        //header view
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileHeaderCollectionReusableView
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return UICollectionReusableView()
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        header.email = safeEmail
        return header
    }
    
    /// heights and widths of headerViews
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.width, height: (collectionView.height)/4)
        }
        return CGSize(width: collectionView.width, height: (collectionView.height)/8)
    }
}

extension ProfileViewController: WishlistButtonCollectionReusableViewDelegate{
    
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
