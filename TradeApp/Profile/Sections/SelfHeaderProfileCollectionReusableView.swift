//
//  SelfHeaderProfileCollectionReusableView.swift
//  TradeApp
//
//  Created by Christina Braun on 29.08.21.
//

//
//  Other_ProfileHeaderCollectionReusableView.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//
//
//import UIKit
//import FirebaseAuth
//import Firebase
//
//
//
//class SelfHeaderProfileCollectionReusableView: UICollectionReusableView {
//
//    static let identifier = "SelfHeaderProfileCollectionReusableView"
//
//
//    public let prfImage: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//        image.backgroundColor = .systemGray
////        let email = UserDefaults.standard.value(forKey: "email") as! String
////        let safeMail = DatabaseManager.safeEmail(emailAdress: email)
////        let path = "images/\(safeMail)_profile_picture.png"
//
////        StorageManager.shared.downloadURL(for: path, completion: { result in
////            switch result {
////            case .success(let url):
////
////                image.sd_setImage(with: url)
////                    print("success geting image")
////
////            case .failure(let error):
////                print("failed to get url: \(error)")
////            }
////        })
//        return image
//    }()
//    
//    var userImage: String! {
//        
//        didSet {
//
//            let path = "post_images/\(userImage!)"
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
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        clipsToBounds = true
//        backgroundColor = .systemBackground
//        addSubview(prfImage)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//       let  size = width/2-5
//        prfImage.frame = CGRect(x: width/4,
//                                y: 10,
//                                    width: size,
//                                    height: size)
//        prfImage.layer.cornerRadius = prfImage.width/2
//    }
//}
