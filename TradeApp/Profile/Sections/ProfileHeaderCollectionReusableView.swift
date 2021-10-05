////
////  ProfileHeaderCollectionReusableView.swift
////  Traide'oro
////
////  Created by Christina Braun on 28.08.21.
////
//
//import UIKit
//import FirebaseAuth
//import Firebase
//
////
//protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
//
////    func DidTapUserProfileImage(_ header: ProfileHeaderCollectionReusableView)
//    func DidTapEditText(_header: ProfileHeaderCollectionReusableView)
//}
//
//class ProfileHeaderCollectionReusableView: UICollectionReusableView {
//
//    static let identifier = "ProfileHeaderCollectionReusableView"
//
//    public weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
//
//    var email: String? {
//        didSet{
//            guard let mail = email else {
//                return
//            }
//            let path = "images/\(mail)_profile_picture.png"
//            StorageManager.shared.downloadURL(for: path, completion: { result in
//                switch result {
//                case .success(let url):
//
//                    DispatchQueue.main.async {
//                        self.prfImage.sd_setImage(with: url)
//                        self.reloadInputViews()
//                    }
//                case .failure(let error):
//                    print("failed to get url: \(error)")
//                }
//            })
//        }
//    }
//
//    public let prfImage: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//        image.backgroundColor = .systemGray
//
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            print("error")
//            return UIImageView()
//        }
//
//        StorageManager.shared.downloadURL(for: "images/\(email)_profile_picture.png", completion: { result in
//            switch result {
//            case .success(let url):
//                image.sd_setImage(with: url)
//            case .failure(let error):
//                print("failed to get url: \(error)")
//            }
//        })
//
//
//        return image
//    }()
//
//    var emailString: String? {
//
//        didSet {
//            print("got email")
//            guard let email = emailString else {
//                return
//            }
//
//            let path = "images/\(email)_profile_picture.png"
//            StorageManager.shared.downloadURL(for: path, completion: { result in
//                switch result {
//                case .success(let url):
//
//                    DispatchQueue.main.async {
//                        self.prfImage.sd_setImage(with: url)
//                    }
//                case .failure(let error):
//                    print("failed to get url: \(error)")
//                }
//            })
//        }
//    }
//
//    //        func downloadImage(imageView: UIButton, url: URL) { // download the url
//    //            URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//    //                guard let data = data, error == nil else {
//    //                    return
//    //                }
//    //                DispatchQueue.main.async {
//    //                    let image = UIImage(data: data)
//    //                    imageView.setBackgroundImage(image, for: .normal)
//    //                }
//    //            }) .resume()
//    //        }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        clipsToBounds = true
//        backgroundColor = .systemBackground
//        addSubview(prfImage)
//
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//        let  size = width/2-5
//
//        prfImage.frame = CGRect(x: width/4,
//                                y: 10,
//                                width: size,
//                                height: size)
//
//        prfImage.layer.cornerRadius = prfImage.width/2
//
//    }
//}

import UIKit
import FirebaseAuth
import Firebase


protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    
    func DidTapUserProfileImage(_ header: ProfileHeaderCollectionReusableView)
    func DidTapEditText(_header: ProfileHeaderCollectionReusableView)
    
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    
    
    public weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    var email: String? {
        didSet{
            guard let mail = email else {
                return
            }
            let path = "images/\(mail)_profile_picture.png"
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    
                    DispatchQueue.main.async {
                        self.prfImage.sd_setImage(with: url)
                        self.reloadInputViews()
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
        }
    }
    
    public let prfImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray
        
        let email = UserDefaults.standard.value(forKey: "email")!
        
        StorageManager.shared.downloadURL(for: "images/\(email)_profile_picture.png", completion: { result in
            switch result {
            case .success(let url):
                image.sd_setImage(with: url)
            case .failure(let error):
                print("failed to get url: \(error)")
            }
        })
        
        
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
                    }
                case .failure(let error):
                    print("failed to get url: \(error)")
                }
            })
        }
    }
    
    //        func downloadImage(imageView: UIButton, url: URL) { // download the url
    //            URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
    //                guard let data = data, error == nil else {
    //                    return
    //                }
    //                DispatchQueue.main.async {
    //                    let image = UIImage(data: data)
    //                    imageView.setBackgroundImage(image, for: .normal)
    //                }
    //            }) .resume()
    //        }
    
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
