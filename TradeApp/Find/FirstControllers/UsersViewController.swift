//
//  UsersViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class UsersViewController: UIViewController {
    
    private var results = [[String: String]]()
    
    private var hasfetched = false
    
    private var users = [[String: String]]()
    
    private var usersearch = [UserCell]()
    
    var userEmail: String?
    
//    let searchController = UISearchController(searchResultsController: ResultsVC())
//    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users"
        return searchBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UserSearchTableViewCell.self,
                       forCellReuseIdentifier: UserSearchTableViewCell.identifier)
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let noResultsLabel: UILabel = {
      let label = UILabel()
        label.isHidden = true
        label.text = "no results"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "End Search", style: .plain, target: self, action: #selector(dismissSelf))
        
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
        
    }
//    let name = results[indexPath.row]["username"]!
//    Database.database().reference().child(name).observeSingleEvent(of: .value, with: {
//        snapshot in
//        guard let userEmail = snapshot.value else {
//            return
//        } })
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width/4,
                                y: (view.height-200)/2,
                                width: view.width/2,
                                height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension  UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: postTableViewCell.identifier, for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchTableViewCell.identifier, for: indexPath) as! UserSearchTableViewCell
//        cell.textLabel?.text = results[indexPath.row]["username"]
        let name = results[indexPath.row]["username"]!
        
//        let model = UserCell(name: "name", userEmail: "userEmail as! String")
            cell.configure(with: name)
            
        return cell
        
//        DatabaseManager.shared.getDataForSearchedEmail(path: name, completion: { result in
//                        switch result {
//                        case .success(let data):
//                            guard let userData = data as? [String: Any],
//                                  let email = userData["email"] as? String
//                            else {
//                                return
//                            }
//            let userEmail = email
//                        case .failure(let error):
//                            print("failed to read data with error \(error)")
//                        }
//
//                    })
//        cell.configure(with: model)
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UserProfileSearchViewController()
        let name = results[indexPath.row]["username"]!
        
        DatabaseManager.database.child("usernames").child(name).child("email").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let email = snapshot.value as? String else {
                return
            }
            vc.maaail = email
        vc.configure(username: name, email: email)
            self.navigationController?.pushViewController(vc, animated: true)

        })
//
//        DatabaseManager.database.child(name).child("email").observeSingleEvent(of: .value, with: {snapshot in
//            guard let email = snapshot.value as? String else {
//                return
//            }
//            print("email is a string \(email)")
////            vc.email.text = email
//            vc.configure(username: name, email: email)
////            vc.eeemail = email
//            print("set email text \(vc.email.text)")
//        })
        
        
        
    }
}

extension  UsersViewController: UISearchBarDelegate {
    
//    func updateSearchResults(for searchController: UISearchController) {
////        guard let text = searchController.searchBar.text else {
////            return
////        }
////        let vc = searchController.searchResultsController as? ResultsVC
////        vc?.view.backgroundColor = .yellow
////        print(text)
//        guard let text = searchController.searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
//            return
//        }
//        searchController.resignFirstResponder()
//        results.removeAll()
//
//        self.searchCountry(query: text)
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        
        self.searchUsers(query: text)
        
        
    }
    
    func searchUsers(query: String) {
        if hasfetched {
            
            filterUsers(with: query)
            
        }
        
        else {
            
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasfetched = true // hasFetched is false by default. Now set it to true
                    self?.users = userCollection
                    print(userCollection)
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
            
        }
        
    }
    
    func filterUsers(with term: String) {
        
        guard hasfetched else {
            return
        }
        
        let results: [[String: String]] = self.users.filter({
            guard let username = $0["username"]?.lowercased(), username != UserDefaults.standard.value(forKey: "username") as! String else {
                return false
            }
            
            return username.hasPrefix(term.lowercased())
        })
        
        self.results = results
        
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}


