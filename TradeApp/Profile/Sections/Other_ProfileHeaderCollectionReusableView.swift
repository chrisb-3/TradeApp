//
//  Other_ProfileHeaderCollectionReusableView.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import Firebase

class Other_ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "Other_ProfileHeaderCollectionReusableView"
    
    public let prfImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray
        return image
    }()
    var emailString: String? {
        
        didSet {
            print("got email")
            guard let email = emailString else {
                return
            }
            
            let path = "images/\(email)_profile_picture.png"
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.prfImage.sd_setImage(with: url)
                        print("success geting image")
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubview(prfImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let  size = width/2-5
        prfImage.frame = CGRect(x: width/4,
                                y: 10,
                                width: size,
                                height: size)
        prfImage.layer.cornerRadius = prfImage.width/2
    }
}
