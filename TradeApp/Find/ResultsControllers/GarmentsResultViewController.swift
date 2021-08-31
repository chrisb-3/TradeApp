//
//  GarmentsResultViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit



class GarmentsSearchResultViewController: UIViewController {
    
    var garmentsResult = [PostInfo]()
  
    let tableView: UITableView = {
        let table = UITableView()
//        table.isHidden = true
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    public func configure(with model: String) {
        
        DatabaseManager.database.child("Search").child("Garments").child(model).observe(.childAdded, with: {
            (snapshot) in
            
            let postId = snapshot.key
            
            DatabaseManager.database.child("posts").child(postId).observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    return
                }
                
                let post = PostInfo(postId: postId, dictionary: dictionary)
                
                self.garmentsResult.append(post)
                
                
                print("Post data\(post)")
                
                self.tableView.reloadData()
            })
        })
        
    }
    

}

extension GarmentsSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return garmentsResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.post = garmentsResult[indexPath.row]
        DatabaseManager.database.child("posts").child(garmentsResult[indexPath.row].postImageNSUUID).child("Exchanged").observeSingleEvent(of: .value, with: { snapshot in
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
        let vc = ClickOnePostViewController(with: "", username: "")
        vc.post = garmentsResult[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
