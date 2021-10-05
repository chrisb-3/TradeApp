//
//  HomeViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

import UIKit
import FirebaseAuth

//struct postStruct {
//    let title : String!
//    let message : String!
//}

class HomeViewController: UIViewController {
    
    var allPosts = [PostInfo]()
    
    let tableView: UITableView = {
        let table = UITableView()
//        table.isHidden = true
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
//    private let noPostsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No posts yet"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        configureNavigationBar()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
        navigationItem.title = "Explore"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
//        noPostsLabel.frame = CGRect(x: 10,
//                                            y: (view.height-100)/2,
//                                            width: view.width-20,
//                                            height: 100)
    }
    
//    check if the user is singed in, If yes show this screen. If no -> go to Login screen
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            validateAuth()
            }
    
        private func validateAuth(){
            if Auth.auth().currentUser == nil {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc) // user is not logged in, go to LogginViewcontroller
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true)
            }
        }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "squareshape.controlhandles.on.squareshape.controlhandles"),
                                                            style: .done ,
                                                            target: self,
                                                            action: #selector(didTapRecomandation))
    }
    @objc private func didTapRecomandation() {
        let vc = RecomandationViewController()
        vc.title = "Recmandation"
        navigationController?.pushViewController(vc, animated: true)
    }
        
    func fetchAllPosts() {
        
        DatabaseManager.database.child("all_posts").observe(.childAdded, with: {
            (snapshot) in
        
            let postId = snapshot.key
            print("all posts: \(postId)")

            
            DatabaseManager.database.child("posts").child(postId).observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    return
                }
               
                let post = PostInfo(postId: postId, dictionary: dictionary)
                
                self.allPosts.append(post)
                
                print("Post data \(post)")
                
                self.tableView.reloadData()
            })
        })
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        guard let postId = allPosts[indexPath.row].postImageNSUUID else {
             return UITableViewCell()
         }
        cell.post = allPosts[indexPath.row]
         DatabaseManager.database.child("posts").child(postId).child("Exchanged").observeSingleEvent(of: .value, with: { snapshot in
             guard let snap = snapshot.value as? String else {
                 return
             }
             print("snapshot \(snapshot)")

             if snap == "gone" {
                 //Item is gone
                 cell.postImage.layer.opacity = 0.5
             }
             //Item is not gone

         })

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.width/2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let email = allPosts[indexPath.row].poster_emial!

        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
            guard let username = snapshot.value as? String else {
                return
            }
            let vc = ClickOnePostViewController(with: safeEmail, username: username)
            vc.post = self.allPosts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        })

    }
}

