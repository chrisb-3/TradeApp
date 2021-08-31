//
//  chatTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

protocol chatTableViewCellDelegatge: AnyObject {
    func DidTapChat()
}

class chatTableViewCell: UITableViewCell {
    
    static let identifier = "chatTableViewCell"
    
    weak var delegate: chatTableViewCellDelegatge?

     let chatButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: config )
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(chatButton)
        chatButton.addTarget(self, action: #selector(didTapStartConversation), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemBackground
        
        chatButton.frame = CGRect(x: 10,
                                  y: 5,
                                  width: height-10,
                                  height: height-10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func didTapStartConversation() {
        delegate?.DidTapChat()
    }

}
