//
//  ConversationTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import SDWebImage
class ConversationTableViewCell: UITableViewCell {
    static let identifier = "ConversationTableViewCell"
    
    var chat: Convo? {
        
        didSet {
            guard let otherUsername = chat?.username! else {
                return
            }
            guard let otherImage = chat?.otherImage!  else {
                return
            }
            guard let message = chat?.latestMessage! else {
                return
            }
            
            userNameLabel.text = otherUsername
            userMessageLabel.text = message
            
            StorageManager.shared.downloadURL(for: otherImage, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.userImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })        }
    }
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)
        userImageView.layer.cornerRadius = userImageView.width/2
        userNameLabel.frame = CGRect(x: userImageView.right + 10,
                                     y: 10,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: (contentView.height - 20)/2)
        userMessageLabel.frame = CGRect(x: userImageView.right + 10,
                                        y: userNameLabel.bottom + 10,
                                        width: contentView.width - 20 - userImageView.width,
                                        height: (contentView.height - 20)/2)
    }
    public func configureMessage(with message: String) {
        self.userMessageLabel.text = message
    }
}
