//
//  postTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

// When a cell is clicked on the profile navigation Navigator in shows a new viewController with the post in bigger. This Cell shows the image

//protocol postTableViewCellDelegate: AnyObject  {
//        func postTableViewCellTapExchanged(_: postTableViewCellDelegate)
//
//    }

class postTableViewCell: UITableViewCell {
                         
//                         postTableViewCellDelegate {
//    func postTableViewCellTapExchanged(_: postTableViewCellDelegate) {
//        DatabaseManager.database.child("posts").child(id).child("Exchanged").setValue("gone")
//    }
    
    
//    weak var delegate: postTableViewCellDelegate?
    
    static let identifier = "postTableViewCell"
    
    var id = String()
    
    var postImg: String? {
        didSet {
               guard let NSUUID = postImg else {
                   return
               }
            self.id = NSUUID
       
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
       //        postImage.image = model.postImage
            
        
           }
    }
    
//    var postImg: PostInfo? {
//        didSet {
//        guard let NSUUID = postImg?.postImageNSUUID else {
//            return
//        }
//
//        let path = "post_images/\(NSUUID)"
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
////        postImage.image = model.postImage
//    }
//    }
    
    let postImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImage)
    }
    
    
    
    public func configure(with model: PostInfo) {
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .systemBackground
        postImage.frame = contentView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc private func didTapExchange() {
//        print("Button clicked")
//        delegate?.postTableViewCellTapExchanged(self)
//    }

}
