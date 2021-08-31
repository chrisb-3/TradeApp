//
//  PhotoPostCollectionViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
import SDWebImage

class PhotoPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoPostCollectionViewCell"
    
//    private let postPhoto: UIImageView = {
//        let image = UIImageView()
//        image.clipsToBounds = true
//        image.contentMode = .scaleAspectFill
//        return image
//    }()
//
//    var post: ProfilePosts? {
//
//        didSet {
//            guard let imageUrl = post?.imageUrl else {
//                return
//            }
//            postPhoto.sd_setImage(with: imageUrl)
//
//        }
//    }
//
//    public func configurePost(with model: String) {
//        postPhoto.image = UIImage(named: model)
//    }
//
////    public func configure(with model: ProfilePosts) {
////
////        postPhoto.sd_setImage(with: model.imageUrl)
////
////        postPhoto.image = UIImage(named: photo)
////        self.postPhoto.sd_setImage(with: ref)
////        postPhoto.image = sd_imageURL(model.image)
////    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        postPhoto.frame = contentView.bounds
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        postPhoto.image = nil
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .lightGray
//        contentView.addSubview(postPhoto)
//        contentView.clipsToBounds = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    public func configure(debug model: String) {
////        postPhoto.image = UIImage(named: model)
////    }
    public func configure(with model: String) {
        postImageView.image = UIImage(named: model)
    }
//
////    public func configure(with model: Post) {
////        let url = model.postImage
////    }
    
    
    var post: PostInfo? {
        
        didSet {
            
            guard let NSUUID = post?.postImageNSUUID else {
                return
            }
            
            let path = "post_images/\(NSUUID)"
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.postImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
            
//            guard let imageUrl = post?.imageUrl else {
//                return
//            }
            
//            postImageView.loadurl(url: imageUrl)
        
//            postImageView.sd_setImage(with: imageUrl)
            
//            DispatchQueue.main.async {
//                self.postImageView.sd_setImage(with: imageUrl)
//            }
            
//            postImageView.sd_setImage(with: imageUrl)
            
            
        }
    }
    
    let postImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            postImageView.frame = contentView.bounds
        }
    
    
}

extension UIImageView {
    func loadurl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
