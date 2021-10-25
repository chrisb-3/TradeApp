//
//  GenderResultViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
class GenderSearchResultViewControllerViewController: UIViewController {
    
    private var genderResults = [PostInfo]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func configure(with model: String)
    
    {
        let gender = model
        DatabaseManager.database.child("Search").child("gender").child(gender).observe(.childAdded, with: {
            (snapshot) in
            let postId = snapshot.key
            DatabaseManager.database.child("posts").child(postId).observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    return
                }
                let post = PostInfo(postId: postId, dictionary: dictionary)
                self.genderResults.append(post)
                print("Post data\(post)")
                self.tableView.reloadData()
            })
        })
    }
}
extension GenderSearchResultViewControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as! PostTableViewCell
        cell.post = genderResults[indexPath.row]
        DatabaseManager.database.child("posts").child(genderResults[indexPath.row].postImageNSUUID).child("Exchanged").observeSingleEvent(of: .value, with: { snapshot in
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.width/2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let email = genderResults[indexPath.row].poster_emial!
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
            guard let username = snapshot.value as? String else {
                return
            }
            let vc = ClickOnePostViewController(with: safeEmail, username: username)
            vc.post = self.genderResults[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
