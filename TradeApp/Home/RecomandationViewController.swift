//
//  RecomandationViewController.swift
//  TradeApp
//
//  Created by Christina Braun on 13.09.21.
//

import UIKit

class RecomandationViewController: UIViewController {
    
    var recomandations = [Recommend]()
//    var count = Int()
    
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "no results"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
        table.register(RecomandationTableViewCell.self, forCellReuseIdentifier: RecomandationTableViewCell.identifier)
//        table.register(ExtraRecomendTableViewCell.self, forCellReuseIdentifier: ExtraRecomendTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        tableView.delegate = self
        tableView.dataSource = self
        fetchRecomandations()
        view.backgroundColor = .systemBackground
//        checkRecomandations()
    }
    
//    func checkRecomandations() {
//        if recomandations.count == 0  {
//            noResultsLabel.isHidden = false
//            tableView.isHidden = true
//    }
//        else{
//            noResultsLabel.isHidden = true
//            tableView.isHidden = false
//        }
//}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width/4,
                                      y: (view.height-200)/2,
                                      width: view.width/2,
                                      height: 200)
        
    }
    
    func fetchRecomandations() {
        
        self.noResultsLabel.isHidden = false
        self.tableView.isHidden = true
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        //Gets all emails
        DatabaseManager.database.child("Emails").observe(.childAdded, with: {
            (snapshot) in
            let emails = snapshot.key
            guard !emails.isEmpty, emails != safeEmail else {
                return
            }
            print("all emails: \(emails)")
            
            //gets all wishes
            DatabaseManager.database.child("Emails").child(emails).child("wishes").observe(.childAdded, with: {
                (snapshot) in
                let otherWish = snapshot.key
                print("all otherWish: \(otherWish)")
                if otherWish.isEmpty {
                    print("nil")
                }
                
                //gets all has
                DatabaseManager.database.child("Emails").child(emails).child("has").observe(.childAdded, with: {
                    (snapshot) in
                    let otherHas = snapshot.key
                    print("all otherHas: \(otherHas)")
                    if otherHas.isEmpty {
                        print("nil")
                    }
                    
                    //gets wishes of current user
                    DatabaseManager.database.child("Emails").child(safeEmail).child("wishes").observe(.childAdded, with: {
                        (snapshot) in
                        let selfWish = snapshot.key
                        print("all selfWish: \(selfWish)")
                        if otherHas.isEmpty {
                            print("nil")
                        }
                        
                        //gets has of current user
                        DatabaseManager.database.child("Emails").child(safeEmail).child("has").observe(.childAdded, with: {
                            (snapshot) in
                            let selfHas = snapshot.key
                            print("all selfHas: \(selfHas)")
                            
                            //check if match
                            if selfWish == otherHas, selfHas == otherWish {
                                print("match")
                                print("\(selfWish), \(otherHas), \(selfHas), \(otherWish)")
                                
                                let Match1Has = otherHas
                                let Match1Wish = otherWish
                                print(Match1Has)
                                print(Match1Wish)
                                
                                // get email of match
                                DatabaseManager.database.child("Emails").child(emails).child("has").child(Match1Has).child("email").observeSingleEvent(of: .value, with: { snapshot in
                                    guard let HasEmail = snapshot.value as? String else{
                                        return
                                    }
                                    print(" other: \(HasEmail)")
                                    
                                    //get id of match
                                    DatabaseManager.database.child("Emails").child(emails).child("has").child(Match1Has).child("id").observeSingleEvent(of: .value, with: { snapshot in
                                        guard let otherId = snapshot.value as? String else{
                                            return
                                        }
                                        print(" other: \(otherId)")
                                        
                                        //Get id of own post
                                        DatabaseManager.database.child("Emails").child(safeEmail).child("wishes").child(Match1Has).child("id").observeSingleEvent(of: .value, with: { snapshot in
                                            guard let selfId = snapshot.value as? String else{
                                                return
                                            }
                                            print(" self: \(selfId)")
                                            
                                            //get info to posts
                                            DatabaseManager.database.child("posts").child(otherId).observeSingleEvent(of: .value, with: { snapshot in
                                                guard let dictionary1 = snapshot.value as? Dictionary<String, AnyObject> else {
                                                    return
                                                }
                                                DatabaseManager.database.child("posts").child(selfId).observeSingleEvent(of: .value, with: { snapshot in
                                                    guard let dictionary2 = snapshot.value as? Dictionary<String, AnyObject> else {
                                                        return
                                                    }
                                                    
                                                    let recomand = Recommend(selfId: selfId, otherId: otherId, dictionary1: dictionary1, dictionary2: dictionary2)
                                                    
                                                    self.recomandations.append(recomand)
//                                                    self.count = self.recomandations.count+1
                                                    self.noResultsLabel.isHidden = true
                                                    self.tableView.isHidden = false
                                                    self.tableView.reloadData()
                                                    
                                                    
                                                })
                                                
                                            })
                                        })
                                    })

                                })
                                                                
                                
                                
//                                DatabaseManager.database.child("Emails").child(safeEmail).child("has").child(selfHas).observeSingleEvent(of: .value, with: {snapshot in
//                                    guard let selfItem = snapshot.value as? String else{
//                                        return
//                                    }
//                                    DatabaseManager.database.child("Emails").child(emails).child("has").child(otherHas).observeSingleEvent(of: .value, with: {snapshot in
//                                        guard let otherItem = snapshot.value as? String else {
//                                            return
//                                        }
//
//                                        DatabaseManager.database.child("posts").child(selfItem).observeSingleEvent(of: .value, with: { snapshot in
//                                            guard let dictionary1 = snapshot.value as? Dictionary<String, AnyObject> else {
//                                                return
//                                            }
//                                            DatabaseManager.database.child("posts").child(selfItem).observeSingleEvent(of: .value, with: { snapshot in
//                                                guard let dictionary2 = snapshot.value as? Dictionary<String, AnyObject> else {
//                                                    return
//                                                }
//
//                                                let recomand = Recomand(selfId: selfItem, otherId: otherItem, dictionary1: dictionary1, dictionary2: dictionary2)
//
//                                                self.recomandations.append(recomand)
//                                                self.count = self.recomandations.count+1
//                                                self.noResultsLabel.isHidden = true
//                                                self.tableView.isHidden = false
//                                                self.tableView.reloadData()
//
//
//                                            })
//
//                                        })
//                                    })
//
//                                })
                                
                            }
                            
                        })
                    })
                    
                })
                
            })
        })
        
    }
}

extension RecomandationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recomandations.count
//        print(recomandations.count + 1)
//       print("rec coun: \(recomandations.count+1)")
//        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row != 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecomandationTableViewCell.identifier, for: indexPath) as! RecomandationTableViewCell
        cell.post = recomandations[indexPath.row]
            return cell
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: ExtraRecomendTableViewCell.identifier, for: indexPath) as! ExtraRecomendTableViewCell
//            cell.delegate = self
//            return cell
//
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == count-1 {
//            tableView.deselectRow(at: indexPath, animated: true)
//            let vc = ExtraRecomandationsViewController()
//    self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//        else {
        DatabaseManager.database.child("posts").child(recomandations[indexPath.row].otherId).child("poster_emial").observeSingleEvent(of: .value, with: { snapshot in
            guard let otherEmail = snapshot.value as? String else {
              return
            }
            DatabaseManager.database.child("Emails").child(otherEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
                        guard let username = snapshot.value as? String else {
                            return
                        }
                        print(username)
            
                DatabaseManager.database.child("posts").child(self.recomandations[indexPath.row].otherId).observeSingleEvent(of: .value, with: { snapshot in
                                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                                    return
                                }
                            print(dictionary)
                    
                    tableView.deselectRow(at: indexPath, animated: true)
        let vc = ClickOnePostViewController(with: otherEmail, username: username)
                    let post = PostInfo(postId: self.recomandations[indexPath.row].otherId , dictionary: dictionary)
vc.post = post
self.navigationController?.pushViewController(vc, animated: true)
                    
                            })
            
            })

        })
//        }
    }
}

//extension RecomandationViewController: ExtraRecomendTableViewCellDelegate {
//    func ExtraRecomendTableViewCellTap(_: ExtraRecomendTableViewCell) {
//        let vc = ExtraRecomandationsViewController()
//self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
