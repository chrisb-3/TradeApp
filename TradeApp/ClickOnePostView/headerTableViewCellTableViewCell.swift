//
//  headerTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import FirebaseDatabase
// When a cell is clicked on the profile navigation Navigator in shows a new viewController with the post in bigger. This Cell shows the header with the user profille image and the username.
protocol headerTableViewCellDelegate: AnyObject {
    func didTapExchanged()
}

class headerTableViewCell: UITableViewCell {
    
    static let identifier = "headerTableViewCell"
    weak var delegate: headerTableViewCellDelegate?
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let username: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let exchanged: UIButton = {
        let button = UIButton()
        button.setTitle("Exchanged", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 12
        button.isHidden = true
        return button
    }()
    
    var postImg: String? {
        didSet {
            guard let NSUUID = postImg else {
                return
            }
            DatabaseManager.database.child("posts").child(NSUUID).child("poster_emial").observeSingleEvent(of: .value, with: {snapshot in
                guard let safeEmail = snapshot.value as? String else{
                    return
                }
                DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    guard let name = snapshot.value as? String else{
                        return
                    }
                    self.username.text = name
                })
                
                let path = "images/\(safeEmail)_profile_picture.png"
                StorageManager.shared.downloadURL(for: path, completion: { result in
                    switch result {
                    case .success(let url):
                        
                        DispatchQueue.main.async {
                            self.profileImage.sd_setImage(with: url)
                        }
                    case .failure(let error):
                        print("failed to get url: \(error)")
                    }
                })
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                let selfEmail = DatabaseManager.safeEmail(emailAdress: email)
                if safeEmail == selfEmail {
                    print("safe: \(safeEmail)")
                    print("self: \(selfEmail)")
                    self.exchanged.isHidden = false
                }
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImage)
        contentView.addSubview(username)
        contentView.addSubview(exchanged)
        exchanged.addTarget(self, action: #selector(TapExchanged), for: .touchUpInside)
    }
    @objc private func TapExchanged() {
        delegate?.didTapExchanged()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with model: String) {
        
        let path = "images/\(model)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self.profileImage.sd_setImage(with: url)
                }
            case .failure(let error):
                print("failed to get url: \(error)")
            }
        })
        Database.database().reference().child("Emails").child(model).child("username").observeSingleEvent(of: .value) {(snapshot) in
            
            guard let usernameText = snapshot.value as? String else { // makes the snapshot a string
                return
            }
            self.username.text = usernameText
        }
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .darkGray
        profileImage.frame = CGRect(x: 5,
                                    y: 5,
                                    width: height-20,
                                    height: height-20)
        profileImage.layer.cornerRadius = profileImage.height/2
        username.frame = CGRect(x: profileImage.right + 5,
                                y: 5,
                                width: width/3,
                                height: height-10)
        exchanged.frame = CGRect(x: width-profileImage.width-username.width,
                                 y: height/4,
                                 width: width/4,
                                 height: height/2)
        exchanged.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        username.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @objc private func didTapExchanged() {
        print("button clicked")
        delegate?.didTapExchanged()
    }
}
