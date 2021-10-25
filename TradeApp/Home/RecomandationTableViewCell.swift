//
//  RecomandationTableViewCell.swift
//  TradeApp
//
//  Created by Christina Braun on 13.09.21.
//

import UIKit
class RecomandationTableViewCell: UITableViewCell {
    
    static let identifier = "RecomandationTableViewCell"
    
    private var selfPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiaryLabel
        return imageView
    }()
    private var otherPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiaryLabel
        return imageView
    }()
    
    private let selfTitel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.text = "Test one"
        return label
    }()
    
    private let otherTitel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.text = "Test two"
        return label
    }()
    
    private let selfUsername: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "Test one"
        return label
    }()
    
    private var otherUsername: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "Test two"
        return label
    }()
    private var selfProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiaryLabel
        imageView.layer.cornerRadius = imageView.height/2
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return imageView
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        let path = "images/\(safeEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    imageView.sd_setImage(with: url)
                }
            case .failure(let error):
                print("failed to get url: \(error)")
            }
        })
        
        return imageView
    }()
    private var otherProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiaryLabel
        imageView.layer.cornerRadius = imageView.height/2
        return imageView
    }()
    
    var post: Recommend? {
        
        didSet {
            
            guard let selfPostId = post?.selfId else {
                return
            }
            print(selfPostId)
            guard let otherPostId = post?.otherId else {
                return
            }
            
            DatabaseManager.database.child("posts").child(otherPostId).child("poster_emial").observeSingleEvent(of: .value, with: { snapshot in
                guard let otherEmail = snapshot.value as? String else {
                    return
                }
                
                let safeOtherEmail = DatabaseManager.safeEmail(emailAdress: otherEmail)
                print("email \(safeOtherEmail)")
                
                let path = "images/\(safeOtherEmail)_profile_picture.png"
                StorageManager.shared.downloadURL(for: path, completion: { result in
                    switch result {
                    case .success(let url):
                        
                        DispatchQueue.main.async {
                            self.otherProfile.sd_setImage(with: url)
                        }
                    case .failure(let error):
                        print("failed to get url: \(error)")
                    }
                })
                
                DatabaseManager.database.child("Emails").child(safeOtherEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    guard let otherUsername = snapshot.value as? String else {
                        return
                    }
                    self.otherUsername.text = otherUsername
                    print("username : \(otherUsername)")
                    
                })
            })
            
            DatabaseManager.database.child("posts").child(selfPostId).child("productTitle").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else {
                    return
                }
                let article = value as? String
                
                self.selfTitel.text = article
            })
            
            DatabaseManager.database.child("posts").child(otherPostId).child("productTitle").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else {
                    return
                }
                let article = value as? String
                
                self.otherTitel.text = article
            })
            
            let path1 = "post_images/\(selfPostId)"
            StorageManager.shared.downloadURL(for: path1, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.selfPostImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
            let path2 = "post_images/\(otherPostId)"
            StorageManager.shared.downloadURL(for: path2, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.otherPostImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
            guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
                return
            }
            self.selfUsername.text = username
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selfPostImageView)
        contentView.addSubview(otherPostImageView)
        contentView.addSubview(selfTitel)
        contentView.addSubview(otherTitel)
        contentView.addSubview(selfUsername)
        contentView.addSubview(otherUsername)
        contentView.addSubview(selfProfile)
        contentView.addSubview(otherProfile)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selfPostImageView.layer.cornerRadius = selfPostImageView.height/2
        otherPostImageView.layer.cornerRadius = otherPostImageView.height/2
        
        selfPostImageView.frame = CGRect(x: width/4-selfPostImageView.width/2,
                                         y: height/2-selfPostImageView.height/2,
                                         width: height/1.5,
                                         height: height/1.5)
        
        otherPostImageView.frame = CGRect(x: width/2+(width/4-otherPostImageView.width/2),
                                          y: height/2-otherPostImageView.height/2,
                                          width: height/1.5,
                                          height: height/1.5)
        
        selfUsername.frame = CGRect(x: width/4-selfPostImageView.width/2+5,
                                    y: 5,
                                    width: width/2,
                                    height: 15)
        otherUsername.frame = CGRect(x: width/2+(width/4-otherPostImageView.width/2)+5,
                                     y: 5,
                                     width: width/2,
                                     height: 15)
        selfProfile.frame = CGRect(x: 10,
                                   y: 5,
                                   width: height/4,
                                   height: height/4)
        selfProfile.layer.cornerRadius = selfProfile.height/2
        
        otherProfile.frame = CGRect(x: width/2+10,
                                    y: 5,
                                    width: height/4,
                                    height: height/4)
        otherProfile.layer.cornerRadius = otherProfile.height/2
        
        selfTitel.frame = CGRect(x: width/4-selfPostImageView.width/2,
                                 y: selfPostImageView.bottom+5,
                                 width: width/2,
                                 height: 15)
        otherTitel.frame = CGRect(x: width/2+(width/4-otherPostImageView.width/2),
                                  y: otherPostImageView.bottom+5,
                                  width: width/2,
                                  height: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
