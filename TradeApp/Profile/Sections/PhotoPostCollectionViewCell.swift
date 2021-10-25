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
