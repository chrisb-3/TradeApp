//
//  descriptionTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

// When a cell is clicked on the profile navigation Navigator in shows a new viewController with the post in bigger. This Cell shows the description

import UIKit
import FirebaseDatabase

class descriptionTableViewCell: UITableViewCell {
    
    static let identifier = "descriptionTableViewCell"
    
    var postData: PostInfo? {
        
        didSet {
    
            guard let NSUUID = postData?.postImageNSUUID else {
                return
            }
            Database.database().reference().child("posts").child(NSUUID).child("productTitle").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.productTitle.text = "\(Text)"
            }
                Database.database().reference().child("posts").child(NSUUID).child("exchangeWish").observeSingleEvent(of: .value) {(snapshot) in
                    print(snapshot)
                    
                    guard let Text = snapshot.value as? String else { // makes the snapshot a string
                        return
                    }
                    self.exchangeWish.text = "exchange wish: \(Text)"
    }
            Database.database().reference().child("posts").child(NSUUID).child("gender").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.gender.text = "\(Text)"
}
            Database.database().reference().child("posts").child(NSUUID).child("city").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.city.text = "city: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("color").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.color.text = "color: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("country").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.country.text = "country: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("productState").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.productState.text = "product state: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("aditionalInformation").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.aditionalInformation.text = "aditional information: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("size").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.size.text = "size: \(Text)"
        }
            Database.database().reference().child("posts").child(NSUUID).child("articleType").observeSingleEvent(of: .value) {(snapshot) in
                print(snapshot)
                
                guard let Text = snapshot.value as? String else { // makes the snapshot a string
                    return
                }
                self.articleType.text = "Article: \(Text)"
        }
    }
    }
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    let articleType: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    let exchangeWish: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    let gender: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    let transactionType: UILabel = {
        let label = UILabel()
        return label
    }()
    let city: UILabel = {
        let label = UILabel()
        return label
    }()
    let country: UILabel = {
        let label = UILabel()
        return label
    }()
    let size: UILabel = {
        let label = UILabel()
        return label
    }()
    let color: UILabel = {
        let label = UILabel()
        return label
    }()
    let productState: UILabel = {
        let label = UILabel()
        return label
    }()
    let aditionalInformation: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(productTitle)
        contentView.addSubview(articleType)
        contentView.addSubview(exchangeWish)
        contentView.addSubview(gender)
        contentView.addSubview(city)
        contentView.addSubview(country)
        contentView.addSubview(size)
        contentView.addSubview(color)
        contentView.addSubview(productState)
        contentView.addSubview(aditionalInformation)
    }

    override func layoutSubviews() {
        let height = contentView.height/20
        productTitle.frame = CGRect(x: 10,
                                    y: 10,
                                    width: width-20,
                                    height: height)
        articleType.frame = CGRect(x: 10,
                                   y: productTitle.bottom+10,
                                   width: width-20,
                                   height: height)
        gender.frame = CGRect(x: 10,
                               y: articleType.bottom+10,
                               width: width-20,
                               height: height)
        country.frame = CGRect(x: 10,
                               y: gender.bottom+10,
                               width: width-20,
                               height: height)
        city.frame = CGRect(x: 10,
                            y: country.bottom+10,
                            width: width-20,
                            height: height)
    
        size.frame = CGRect(x: 10,
                            y: city.bottom+10,
                            width: width-20,
                            height: height)
        color.frame = CGRect(x: 10,
                             y: size.bottom+10,
                             width: width-20,
                             height: height)
        productState.frame = CGRect(x: 10,
                                    y: color.bottom+10,
                                    width: width-20,
                                    height: height)
        exchangeWish.frame = CGRect(x: 10,
                                    y: productState.bottom+10,
                                    width: width-20,
                                    height: height)
        aditionalInformation.frame = CGRect(x: 10,
                                            y: exchangeWish.bottom+10,
                                            width: width-20,
                                            height: 80)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}

