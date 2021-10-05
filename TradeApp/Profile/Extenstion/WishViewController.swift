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
    }
    let usernameAndTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
       
        return label
    }()
    
    let list: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkGray
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.numberOfLines = 0
        label.layer.cornerRadius = 12
        label.sizeToFit()
        label.center = .zero
        label.layer.masksToBounds = true
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        
        return label
    }()
//
    public func configure(with model: String){
        
       
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
            let text = "'s Wishlist: "
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
    }
}
