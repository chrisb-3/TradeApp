//
//  PostTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"

    let postImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    let gender: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    let articleType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let city: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let country: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let size: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let color: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let productState: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let inExchange: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImage)
        contentView.addSubview(username)
        contentView.addSubview(productTitle)
        contentView.addSubview(gender)
        contentView.addSubview(city)
        contentView.addSubview(country)
        contentView.addSubview(size)
        contentView.addSubview(color)
        contentView.addSubview(productState)
        contentView.addSubview(articleType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: PostInfo? {
        
        didSet {
            
            guard let NSUUID = post?.postImageNSUUID else {
                return
            }
    
            guard let email = post?.poster_emial else {
                return
            }
            articleType.text = post?.articleType
            gender.text = post?.gender
            productTitle.text = post?.productTitle
            city.text = post?.city
            country.text = post?.country
            let sizeText = post?.size
            let sizeT = "size: "
            size.text = sizeT+sizeText!
            let colorText = post?.color
            let colorT = "color: "
            color.text = colorT+colorText!
            let productStateText = post?.productState
            let productStateT = "product state: "
            productState.text = productStateT+productStateText!
            
            DatabaseManager.database.child("Emails").child(email).child("username").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else {
                  return
                }
                let username = value as? String
                self.username.text = username
            })
            
            DatabaseManager.database.child("posts").child(NSUUID).child("articleType").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else {
                  return
                }
                let article = value as? String

                self.articleType.text = article
            })
            
            let path = "post_images/\(NSUUID)"
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.postImage.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        username.text = nil
        articleType.text = nil
        productTitle.text = nil
        gender.text = nil
        city.text = nil
        country.text = nil
        size.text = nil
        color.text = nil
        productState.text = nil
    }
    
    override func layoutSubviews() {
        postImage.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width/2,
                                 height: width/2)
        
        username.frame = CGRect(x: postImage.right+10,
                                y: 10,
                                width: width/2,
                                height: height/8)
        
        productTitle.frame = CGRect(x: postImage.right+10,
                                    y: username.bottom,
                                    width: width/2,
                                    height: height/8)
        
        city.frame = CGRect(x: postImage.right+10,
                            y: productTitle.bottom+5,
                            width: width/4,
                            height: height/10)
        
        country.frame = CGRect(x: city.right,
                               y: productTitle.bottom+5,
                               width: width/2-20,
                               height: height/10)
        
        size.frame = CGRect(x: postImage.right+10,
                            y: country.bottom+5,
                            width: width/2-20,
                            height: height/10)
        
        color.frame = CGRect(x: postImage.right+10,
                             y: size.bottom,
                             width: width/2-20,
                             height: height/10)
        
        productState.frame = CGRect(x: postImage.right+10,
                                    y: color.bottom,
                                    width: width/2-20,
                                    height: height/10)
        articleType.frame = CGRect(x: postImage.right+10,
                                   y: productState.bottom + 20,
                                   width: width/2-20,
                                   height: height/10)
    }
}
