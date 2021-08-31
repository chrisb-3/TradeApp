//
//  PostTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
import FirebaseDatabase

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
//    let transactionType: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.numberOfLines = 0
//        return label
//    }()
    
//    let priceLabel: UILabel = {
//        let label = UILabel()
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.secondaryLabel.cgColor
//        label.font = .systemFont(ofSize: 13, weight: .semibold)
//        label.textColor = .label
//        label.numberOfLines = 0
//        return label
//    }()
    
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
//        contentView.addSubview(transactionType)
//        contentView.addSubview(priceLabel)
        contentView.addSubview(gender)
        contentView.addSubview(city)
        contentView.addSubview(country)
        contentView.addSubview(size)
        contentView.addSubview(color)
        contentView.addSubview(productState)
//        contentView.addSubview(inExchange)
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
//            inExchange.text = post?.exchangeWish
            city.text = post?.city
            country.text = post?.country
            let sizeText = post?.size
            let sizeT = "size: "
            size.text = sizeT+sizeText!
            
            let colorText = post?.color
            let colorT = "color: "
            color.text = colorT+colorText!
            
//            articleType.text = post?.articleType
            
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
//    
//    public func configure(with model: SearchResults) {
//        postImage.image = model.postImage
//        
//        username.text = model.postInfo.username
//        productTitle.text = model.postInfo.productTitle
////        inExchange.text = model.postInfo.inExchange
//        articleType.text = model.postInfo.articelType
//        gender.text = model.postInfo.gender
//        city.text = model.postInfo.city
//        country.text = model.postInfo.country
//        size.text = model.postInfo.size
//        articleType.text = model.postInfo.articelType
//        color.text = model.postInfo.color
//        productState.text = model.postInfo.productState
//        
//    }
    
    public func configureWithCountry(with model: String) {

//        DatabaseManager.database.child("search").child(model).observeSingleEvent(of: .value, with: {(snapshot) in
//
//            guard let uid = snapshot.value as? String else {
//                return
//            }
////
//            Database.database().reference().child(uid).child("productTitle").observeSingleEvent(of: .value) {(snapshot) in
//                print(snapshot)
//
//                guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                    return
//                }
//                self.productTitle.text = "Title: \(Text)"
//            }
//
//
//            Database.database().reference().child(uid).child("exchangeWish").observeSingleEvent(of: .value) {(snapshot) in
//                print(snapshot)
//
//                guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                    return
//                }
//                self.exchangeWish.text = "exchange wish: \(Text)"
//}
//
//            Database.database().reference().child(uid).child("city").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            self.city.text = "city: \(Text)"
//    }
//            Database.database().reference().child(uid).child("color").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            self.color.text = "color: \(Text)"
//    }
//            Database.database().reference().child(uid).child("country").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            self.country.text = "country: \(Text)"
//    }
//            Database.database().reference().child(uid).child("productState").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            self.productState.text = "productState: \(Text)"
//    }
//            Database.database().reference().child(uid).child("size").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let Text = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            self.size.text = "size: \(Text)"
//    }


//        let path = "post_images/\(uid)"
//        StorageManager.shared.downloadURL(for: path, completion: { result in
//            switch result {
//            case .success(let url):
//
//                DispatchQueue.main.async {
//                    self.postImage.sd_setImage(with: url)
//                }
//            case .failure(let error):
//                print("failed to get url: \(error)")
//            }
//        })
//        })



//        postImage.image = model.postImage
//        username.text = model.username
//        productTitle.text = model.productTitle
//        exchangeWish.text = model.exchangeWish
////        transactionType.text = model.transactionType
////        priceLabel.text = model.priceLabel
//        city.text = model.city
//        country.text = model.country
//        size.text = model.size
//        color.text = model.color
//        productState.text = model.productState
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        username.text = nil
        articleType.text = nil
        productTitle.text = nil
        gender.text = nil
//        inExchange.text = nil
//        transactionType.text = nil
//        priceLabel.text = nil
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
        
//        transactionType.frame = CGRect(x: postImage.right+10,
//                                       y: productTitle.bottom,
//                                       width: width/4,
//                                       height: height/8)
        
//        priceLabel.frame = CGRect(x: transactionType.right,
//                                  y: productTitle.bottom,
//                                  width: width/5,
//                                  height: height/10)
        
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
//        inExchange.frame = CGRect(x: postImage.right+10,
//                                    y: productState.bottom,
//                                    width: width/2-20,
//                                    height: height/10)
        articleType.frame = CGRect(x: postImage.right+10,
                                   y: productState.bottom + 20,
                                   width: width/2-20,
                                   height: height/10)
    }
}
