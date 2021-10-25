//
//  UserSearchTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import SDWebImage
import FirebaseDatabase

class UserSearchTableViewCell: UITableViewCell {
    
    static let identifier = "UserSearchTableViewCell"
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: height-20,
                                     height: height-20)
        userImageView.layer.cornerRadius = userImageView.width/2
        
        userNameLabel.frame = CGRect(x: userImageView.right + 10,
                                     y: contentView.height/4,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: (contentView.height - 20)/2)
    }
    
    public func  configure(with model: String) {
        
        self.userNameLabel.text = model
        
        Database.database().reference().child("usernames").child(model).child("email").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let value = snapshot.value else {
                return
            }
            
            guard let mail = value as? String else {
                return
            }
            let path = "images/\(mail)_profile_picture.png"
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    
                    self.userImageView.sd_setImage(with: url)
                    
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
        })
    }
}
