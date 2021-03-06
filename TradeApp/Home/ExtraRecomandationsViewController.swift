////
////  ExtraRecomandationsViewController.swift
////  TradeApp
////
////  Created by Christina Braun on 15.09.21.
////
//
//import UIKit
//
//class ExtraRecomandationsViewController: UIViewController {
//
//    var recomandations = [Recommend]()
//
//    let noResultsLabel: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "no results"
//        label.textAlignment = .center
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        return label
//    }()
//
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.isHidden = false
//        table.register(RecomandationTableViewCell.self, forCellReuseIdentifier: RecomandationTableViewCell.identifier)
//        table.register(ExtraRecomendTableViewCell.self, forCellReuseIdentifier: ExtraRecomendTableViewCell.identifier)
//        return table
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        view.addSubview(noResultsLabel)
//        tableView.delegate = self
//        tableView.dataSource = self
//        fetchExtaRecomandations()
////        fetchRecomandations()
//        view.backgroundColor = .systemBackground
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//        noResultsLabel.frame = CGRect(x: view.width/4,
//                                      y: (view.height-200)/2,
//                                      width: view.width/2,
//                                      height: 200)
//
//    }
//
//    func fetchExtaRecomandations() {
//
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//        print("teest")
//
//        ///gets all emails
//        DatabaseManager.database.child("Emails").observe(.childAdded, with: {
//            (snapshot) in
//            let emails = snapshot.key
//            guard !emails.isEmpty, emails != safeEmail else {
//                return
//            }
//            print("all emails: \(emails)")
//
//            ///gets wishes for other
//            DatabaseManager.database.child("Emails").child(emails).child("wishes").observe(.childAdded, with: {
//                (snapshot) in
//                let otherWish = snapshot.key
//                print("all otherWish: \(otherWish)")
//
//                ///check if otherWish == selfHas
//                DatabaseManager.database.child("Emails").child(safeEmail).child("has").observe(.childAdded, with: {
//                    (snapshot) in
//                    let selfHas = snapshot.key
//                    guard let selfItem = snapshot.value as? String else {
//                    return
//                }
//                    print("all otherHas: \(selfHas)")
//                    print("all otherHas: \(selfItem)")
//
//
//                    if otherWish == selfHas {
//                        print("mathch")
//                        DatabaseManager.database.child("Emails").child(emails).child("wishes").observe(.childAdded, with: {
//                            (snapshot) in
//                            let otherWish = snapshot.key
//                            print("all otherWish: \(otherWish)")
//                    })
//                    }
//
//                    ///no match
//                })
//
//            })
//        })
//    }
//}
//
//extension ExtraRecomandationsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return recomandations.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RecomandationTableViewCell.identifier, for: indexPath) as! RecomandationTableViewCell
//        cell.post = recomandations[indexPath.row]
//        if indexPath.row == recomandations.count + 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: ExtraRecomendTableViewCell.identifier, for: indexPath) as! ExtraRecomendTableViewCell
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        DatabaseManager.database.child("posts").child(recomandations[indexPath.row].otherId).child("poster_emial").observeSingleEvent(of: .value, with: { snapshot in
//            guard let otherEmail = snapshot.value as? String else {
//              return
//            }
//            DatabaseManager.database.child("Emails").child(otherEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
//                        guard let username = snapshot.value as? String else {
//                            return
//                        }
//                        print(username)
//
//                DatabaseManager.database.child("posts").child(self.recomandations[indexPath.row].otherId).observeSingleEvent(of: .value, with: { snapshot in
//                                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
//                                    return
//                                }
//                            print(dictionary)
//
//
//        let vc = ClickOnePostViewController(with: otherEmail, username: username)
//                    let post = PostInfo(postId: self.recomandations[indexPath.row].otherId , dictionary: dictionary)
//vc.post = post
//self.navigationController?.pushViewController(vc, animated: true)
//
//                            })
//
//            })
//
//        })
//    }
//}
//
