//
//  WishViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit

class WishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(list)
        view.addSubview(usernameAndTextLabel)
        view.backgroundColor = .systemBackground
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        return tableView
//    }()
    
//    func heightForView(text:String, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//       label.numberOfLines = 0
//       label.lineBreakMode = NSLineBreakMode.byWordWrapping
//       label.text = text
//
//       label.sizeToFit()
//       return label.frame.height
//   }
//
//   let font = UIFont(name: "Helvetica", size: 20.0)

    let usernameAndTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
//            label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.layer.masksToBounds = true
//            label.center = .zero
//            label.sizeToFit()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
//        let email = UserDefaults.standard.value(forKey: "email") as? String
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email!)
//
//        DatabaseManager.database.child(safeEmail).child("username").observeSingleEvent(of: .value, with: {
//            snapshot in
//            guard let username = snapshot.value as? String else {
//                return
//            }
//            let text = "s wishlist: "
//            label.text = username+text
//            label.font = .systemFont(ofSize: 20, weight: .heavy)
////            label.adjustsFontForContentSizeCategory = true
//            label.numberOfLines = 0
//            label.layer.masksToBounds = true
////            label.center = .zero
////            label.sizeToFit()
//            label.layer.masksToBounds = true
//            label.lineBreakMode = NSLineBreakMode.byWordWrapping

//        })
        return label
    }()
    
    let list: UILabel = {
        let label = UILabel()

//        let email = UserDefaults.standard.value(forKey: "email") as? String
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email!)
//
//        DatabaseManager.database.child(safeEmail).child("Wishlist").observeSingleEvent(of: .value, with: {
//            snapshot in
//            guard let listResult = snapshot.value as? String else {
//                return
//            }
//            label.text = listResult
//            label.textColor = .black
//        })
//
//        label.font = UIFont.preferredFont(forTextStyle: .body)
//        label.adjustsFontForContentSizeCategory = true
//        label.textColor = .darkGray
//        label.backgroundColor = .systemGray5
//        label.numberOfLines = 0
////        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.layer.cornerRadius = 12
//        label.sizeToFit()
//        label.center = .zero
//        label.layer.masksToBounds = true
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
//
    public func configure(with model: String){
        
//        let list = UILabel()
//        let title = UILabel()
        list.font = UIFont.preferredFont(forTextStyle: .body)
        list.adjustsFontForContentSizeCategory = true
        list.textColor = .darkGray
        list.backgroundColor = .systemGray5
        list.textColor = .black
        list.numberOfLines = 0
//      label.lineBreakMode = NSLineBreakMode.byWordWrapping
        list.layer.cornerRadius = 12
        list.sizeToFit()
        list.center = .zero
        list.layer.masksToBounds = true
        list.textAlignment = .left
        list.font = .systemFont(ofSize: 20, weight: .regular)
        
//        list.frame = CGRect(x:25,
//                                   y: title.bottom+10,
//                                   width: view.width-50,
//                                   height: view.height-140)
        
        
        
//            title.frame = CGRect(x: 25,
//                                 y: 40,
//                                 width: self.view.width-50,
//                                 height: 50)
        
        DatabaseManager.database.child("Emails").child(model).child("Wishlist").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let listResult = snapshot.value as? String else {
                return
            }
            
            self.list.text = listResult
        })
        DatabaseManager.database.child("Emails").child(model).child("username").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let username = snapshot.value as? String else {
                return
            }
            let text = "s wishlist: "
            self.usernameAndTextLabel.text = username+text
           
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameAndTextLabel.frame = CGRect(x: 25,
                                            y: 40,
                                            width: view.width-50, height: 50)
        list.frame = CGRect(x:25,
                            y: usernameAndTextLabel.bottom+10,
                            width: view.width-50,
                            height: view.height-140)
//        list.frame = CGRect(x: 25, y: view.height/2, width: view.width, height: CGFloat.greatestFiniteMagnitude)
    }

}

//extension WishViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//            CGFloat rowHeight = cell.myUILabel.frame.size.height + 10;
//
//            return rowHeight;
//    }
//
//
//}
