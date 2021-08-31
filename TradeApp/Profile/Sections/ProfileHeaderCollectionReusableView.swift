//
//  ProfileHeaderCollectionReusableView.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

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
    
    
    
//    public func configure(with model: String) {
//
//        let path = "images/\(model)_profile_picture.png"
//        StorageManager.shared.downloadURL(for: path, completion: { result in
//            switch result {
//            case .success(let url):
//                print(model)
//            DispatchQueue.main.async {
////                button.sd_setImage(with: url, for: .normal, completed: nil)
//                self.prfImage.sd_setImage(with: url)
//                self.prfImage.backgroundColor = .orange
//            }
//            case .failure(let error):
//            print("failed to get url: \(error)")
//            }
//        })
//
//    }
    
//    let userQuoteText: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 30
//        view.backgroundColor = .tertiarySystemGroupedBackground
//        return view
//    }()
//
//    let editText: UIButton = {
//        let button = UIButton()
//        button.setTitle("Eddit Text", for: .normal)
//        button.setTitleColor(.lightGray, for: .normal)
//        return button
//    }()
    
//    public let UImageButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .green
//        return button
//    }()
    
//    ///button bar with {badges and points, user description, sold items, editProfile(on profileViewController), startChatBuble(on other users profile)}
//
//    let buttonBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = .blue
//        return view
//    }()
//
//    let badgeButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .cyan
//        button.setBackgroundImage(UIImage(systemName: "bookmark.circle"), for: .normal)
//        return button
//    }()
//
//    let userDescriptionButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .white
//        button.setBackgroundImage(UIImage(systemName: "newspaper"), for: .normal)
//        return button
//    }()
//
//    let soldItemsButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .white
//        button.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
//        return button
//    }()
//
////    let button4: UIButton = {
////        let button = UIButton()
////        button.tintColor = .black
////        return button
////    }()
//
//    let editProfileButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .white
//        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
//        return button
//    }()
//
////    let startChatButton: UIButton = {
////        let button = UIButton()
////        button.tintColor = .black
////        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
////        return button
////    }()
//
//    private var pointsLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
////        label.text = "Points: 230"
//        label.font = .systemFont(ofSize: 15, weight: .regular)
//        label.numberOfLines = 0
//
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return UILabel()
//        }
//
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//        Database.database().reference().child(usersafeEmail).child("profile_data").child("points").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            let points = snapshot.value as? String
//            let Points = "Points: "
//            label.text = Points+points!
//        }
//
////        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
////            return UILabel()
////        }
////
////        let safeMail = DatabaseManager.safeEmail(emailAdress: email)
////
////        DatabaseManager().database.child(safeMail).child("profile_data").child("points").observeSingleEvent(of: .value ) { (snapshot) in
////
////            guard let points = snapshot.value as? String else {
////                return
////            }
////            print("\(snapshot)")
////            label.text = "Points: \(points)"
////        }
//
//        return label
//    }()
//
//    private let postsLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .label
////        label.text = "Points: 230"
//        label.font = .systemFont(ofSize: 15, weight: .regular)
//        label.numberOfLines = 0
//
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return UILabel()
//        }
//
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//        Database.database().reference().child(usersafeEmail).child("profile_data").child("posts").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            let posts = snapshot.value as? String
//            let Posts = "Points: "
//            label.text = Posts+posts!
//        }
//        return label
//    }()
//
//    private let soldLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .label
////        label.text = "Points: 230"
//        label.font = .systemFont(ofSize: 15, weight: .regular)
//        label.numberOfLines = 0
//
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return UILabel()
//        }
//
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//        Database.database().reference().child(usersafeEmail).child("profile_data").child("sold").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            let sold = snapshot.value as? String
//            let Sold = "Sold: "
//            label.text = Sold+sold!
//        }
//        return label
//    }()
    
//    private let quoteLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "Inseart a quote you like or your life motto :)Inseart a quote you like or your life motto :)Inseart a quote you like or your life motto :)Inseart a quote you like or your life motto :)Inseart a quote you like or your life motto :)Inseart a quote you like or your life motto :) "
//        label.font = .systemFont(ofSize: 15, weight: .light)
//        label.numberOfLines = 3
////        label.preferredMaxLayoutWidth = 20
////        label.lineBreakMode = .byTruncatingTail
//        return label
//    }()
    
//    private let locationLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "Geneva, Switzerland "
//        label.font = .systemFont(ofSize: 15, weight: .medium)
//        label.numberOfLines = 0
//        return label
//    }()

    
    
//        profileImage.image = UIImage(named: model)
        
//        pointsLabel.text = ("\(model.points)")
        
//        postsLabel.text = ("\(model.postNumber)")
        
//        soldLabel.text = ("\(model.soltPosts)")
//        quoteLabel.text = model.userQuote
//        locationLabel.text = model.location
        
//        Database.database().reference().child(model).child("profile_data").child("points").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let points = snapshot.value as? String else {
//                return
//            }
//            let labelWidth = CGFloat(20)
//            let labelHight = CGFloat(50)
//
//            let pointsL = UILabel()
//            pointsL.frame = CGRect(x: pointsL.bottom+10,
//                                       y: 5,
//                                       width: labelWidth,
//                                       height: labelHight)
//            pointsL.text = points
//            pointsL.textColor = .label
//            pointsL.font = .systemFont(ofSize: 15, weight: .regular)
//            pointsL.numberOfLines = 0
////            self.pointsLabel = pointsL
//        }
        
//        let path = "images/\(model.email)_profile_picture.png"
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//
//            DispatchQueue.main.async {
//                self?.prfImageButton.sd_setImage(with: url, for: .normal, completed: nil)
//            }
//            case .failure(let error):
//            print("failed to get url: \(error)")
//            }
//        })
        
        
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//        Database.database().reference().child(usersafeEmail).child("profile_data").child("points").observeSingleEvent(of: .value) { (snapshot) in
//            print("\(snapshot)")
//
//            guard let points = snapshot.value as? String else {
//                return
//            }
//            let label = UILabel()
//            label.textColor = .label
//    //        label.text = "Points: 230"
//            label.font = .systemFont(ofSize: 15, weight: .regular)
//            label.numberOfLines = 0
//            label.text = "Points: points"
//            self.pointsLabel = label
////            self.postsLabel.text = "Points: \(points)"
//        }
    
    
    
    
//    func theProfileImage() -> UIButton? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//        return nil
//    }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//        let filename = safeEmail + "_userprofile_picture.png" // this is what the image is called (email + ending)
//
//            let path = "images/"+filename
//
//    //    button.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
//
//    //    let profImageView = UIView(frame: CGRect(x: 5,
//    //                                             y: 5,
//    //                                             width: size,
//    //                                             height: size))
//
//        prfImageButton.layer.masksToBounds = true
//        prfImageButton.setTitleColor(.white, for: .normal)
//        prfImageButton.tintColor = .darkText
//        prfImageButton.backgroundColor = .systemRed
//        prfImageButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        prfImageButton.layer.cornerRadius = prfImageButton.width/2
//
//
////        let  size = width/2-5
////        let imageView = UIImageView(frame: CGRect(x: 5,
////                                                   y: 5,
////                                                   width: width/2,
////                                                   height: size))
//
//
////       imageView.contentMode = .scaleAspectFill
////        imageView.layer.cornerRadius = imageView.width/2
////        imageView.backgroundColor = .white
//////        imageView.layer.borderColor = UIColor.white.cgColor
//////        imageView.layer.borderWidth =  3
////        imageView.layer.masksToBounds = true
//
//
//
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//                self?.downloadImage(imageView: self!.prfImageButton, url: url)
//            case .failure(let error):
//                print("Failed to get url: \(error)")
//            }
//        })
//        return prfImageButton
////    return imageView
//    //    return profImageView
//    }

    

        func downloadImage(imageView: UIButton, url: URL) { // download the url
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    imageView.setBackgroundImage(image, for: .normal)
//                    imageView.image = image
                }
            }) .resume()
        }
    
//    private func fetchPointsData() {

//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//
//        let usersafeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//        Database.database().reference().child(usersafeEmail).child("profile_data").child("points").observeSingleEvent(of: .value) {(snapshot) in
//            print(snapshot)
//
//            guard let points = snapshot.value as? String else { // makes the snapshot a string
//                return
//            }
//            let labelWidth = CGFloat(20)
//            let labelHight = CGFloat(50)
//
//            let pointsL = UILabel()
//            pointsL.frame = CGRect(x: pointsL.bottom+10,
//                                       y: 5,
//                                       width: labelWidth,
//                                       height: labelHight)

//            pointsL.textColor = .label
//            pointsL.font = .systemFont(ofSize: 15, weight: .regular)
//            pointsL.numberOfLines = 0
//            pointsL.text = points
//            self.pointsLabel.frame = CGRect(x: self.pointsLabel.bottom+10,
//                                       y: 5,
//                                       width: labelWidth,
//                                       height: labelHight)
//
//            self.pointsLabel.textColor = .label
////            self.pointsLabel.text = "Posts: 59"
//            self.pointsLabel.font = .systemFont(ofSize: 15, weight: .regular)
//            self.pointsLabel.numberOfLines = 0
//            pointsL.text = points
            
//            self.pointsLabel = pointsL
//        }

//    }

    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
//        addSubview(profileImage)
        
//        addSubview(pointsLabel)
//        addSubview(postsLabel)
//        addSubview(soldLabel)
        
//        addSubview(quoteLabel)
//        addSubview(locationLabel)
        addSubview(prfImage)
//        addSubview(userQuoteText)
//        addSubview(editText)
//        fetchPointsData()
        
//        let UImageButton = theProfileImage()
        
//        userDescriptionButton.addTarget(self, action: #selector(didTapUseInfo), for: .touchUpInside)
        
//        addSubview(UImageButton!)
        
//        addSubview(theProfileImage()!)
        
//        addSubview(buttonBar)
//        addSubview(badgeButton)
//        addSubview(userDescriptionButton)
//        addSubview(soldItemsButton)
//        addSubview(editProfileButton)
        
//        addSubview(startChatButton)
//        buttonActions()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func buttonActions() {
//    userDescriptionButton.addTarget(self, action: #selector(didTapuserDescriptionButton), for: .touchUpInside)
//    badgeButton.addTarget(self, action:#selector(didTapbadgeButton), for: .touchUpInside)
//        soldItemsButton.addTarget(self, action:#selector(didTapsoldItemsButton), for: .touchUpInside)
//        editProfileButton.addTarget(self, action:#selector(didTapeditProfileButton), for: .touchUpInside)
//    }
    
    //    prsoldItemsButton.addivate func buttonTaped() {
////        theProfileImage()!.addTarget(self, action: #selector(didTapProfileImage), for: .touchUpInside)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let url = returnURL(with: "bob@gmail.com")
//
//
//        let image = ProfileHeaderCollectionReusableView.downloadImagee(withURL: url!, completion: { [weak self] result in
//
//            ProfileHeaderCollectionReusableView.downloadImagee(withURL: url, completion: {
//
//            } )
//
//        })
        
        
       let  size = width/2-5
//        profileImage.layer.cornerRadius = (size)/2
//        button.frame = CGRect(x: 5,
//                                    y: 5,
//                                    width: size,
//                                    height: size)
//        let UPImage = theProfileImage()
//
//
        
        prfImage.frame = CGRect(x: width/4,
                                y: 10,
                                    width: size,
                                    height: size)

        prfImage.layer.cornerRadius = prfImage.width/2
        
//        userQuoteText.frame = CGRect(x: prfImage.right+10,
//                                     y: 5,
//                                     width: size-20,
//                                     height: size)
//
////        let textposition = prfImageButton.width+40
//        editText.frame = CGRect(x: width/2+(width/8-10),
//                                y: height/2,
//                                width: (size-20)/1.5,
//                                height: 30)
        
//        let labelWidth = width/4
//        let labelHight = CGFloat(50)
//        pointsLabel.frame = CGRect(x: theProfileImage()!.right+10,
//        pointsLabel.frame = CGRect(x: prfImageButton.bottom+10,
//                                   y: 5,
//                                   width: labelWidth,
//                                   height: labelHight)
////        postsLabel.frame = CGRect(x: theProfileImage()!.right+10,
//        postsLabel.frame = CGRect(x: prfImageButton.bottom+10,
//                                  y: pointsLabel.bottom,
//                                   width: labelWidth,
//                                   height: labelHight)
////        soldLabel.frame = CGRect(x: theProfileImage()!.right+10,
//        soldLabel.frame = CGRect(x: prfImageButton.bottom+10,
//                                 y: postsLabel.bottom,
//                                   width: labelWidth,
//                                   height: labelHight)
        
//        locationLabel.frame = CGRect(x: 5, y: theProfileImage()!.bottom+10,
//        locationLabel.frame = CGRect(x: 5, y: prfImageButton.bottom+10,
//                                  width: width,
//                                  height: 20)
//        quoteLabel.frame = CGRect(x: 5,
//                                  y: locationLabel.bottom,
//                                  width: width-20,
//                                  height: 80)

//        let buttonBarHeight = height-90
//        let xBar = pointsLabel.right+15
//        let BarWidth = width/7
//        let ButtonSize = BarWidth-10
//        buttonBar.frame = CGRect(x: xBar,
//                                 y: 10,
//                                 width: width/7,
//                                 height: buttonBarHeight)
//        buttonBar.layer.cornerRadius = 10
//
//        badgeButton.frame = CGRect(x: xBar+5,
//                                   y: 15,
//                                   width: ButtonSize,
//                                   height: ButtonSize)
//        userDescriptionButton.frame = CGRect(x: xBar+5,
//                                             y: badgeButton.bottom+5,
//                                   width: ButtonSize,
//                                   height: ButtonSize)
//        soldItemsButton.frame = CGRect(x: xBar+5,
//                                   y: userDescriptionButton.bottom+5,
//                                   width: ButtonSize,
//                                   height: ButtonSize)
//
//        editProfileButton.frame = CGRect(x: xBar+5,
//                                   y: soldItemsButton.bottom+5,
//                                   width: ButtonSize,
//                                   height: ButtonSize)
        
        
//        startChatButton.frame = CGRect(x: xBar+5,
//                                   y: soldItemsButton.bottom+5,
//                                   width: ButtonSize,
//                                   height: ButtonSize)
    }
    
//    @objc func didTapuserDescriptionButton() {
//        delegate?.DidTapUserDescriptionButton(_header: self)
//    }
//    @objc func didTapbadgeButton() {
//        delegate?.DidTapUserBadgeButton(_header: self)
//    }
//    @objc func didTapsoldItemsButton() {
//        delegate?.DidTapSoldPostsButton(_header: self)
//    }
//    @objc func didTapeditProfileButton() {
//        delegate?.DidTapEditProfileButton(_header: self)
//    }
//    @objc func didTapStartConversation() {
//        delegate?.DidTapEditProfileButton(_header: self)
//    }
    
    
    
    
//    @objc func didTapUseInfo() {
//        delegate?.DidTapUserDescriptionButton(_header: self)
    }
//    public func configureChatEdit(debug imageType: ChatOrEdit) {
//        self.button4.setBackgroundImage(UIImage(systemName: imageType), for: .normal)
//        button4.addTarget(self, action: imageType, for: .touchUpInside)
//
//    }
    
    
//    @objc private func didTapProfileImage() {
//        delegate?.DidTapUserProfileImage(self)
//    }
    
//    @objc private func didTapuserInfo() {
//        delegate?.DidTapUserDescriptionButton(_header: self)
//    }
    
//}

//extension ProfileHeaderCollectionReusableView: ProfileHeaderCollectionReusableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func DidTapUserProfileImage(_ header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapUserBadgeButton(_header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapUserDescriptionButton(_header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapSoldPostsButton(_header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapStartChatButton(_header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    func DidTapEditProfileButton(_header: ProfileHeaderCollectionReusableView) {
//
//    }
//
//    /// actions when the  square buttons are clicked
//    func DidTapUserBadgeButton(_header: ProfileHeaderCollectionReusableViewDelegate) {
//        // show new view with all badges this user has
//    }
//
//    func presentPhotoActionSheet() {
//        let actionSheet = UIAlertController(title: "Profile Picture", message: "select a profile Image", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Cancel",
//                                            style: .cancel,
//                                            handler: nil))
//        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
//                                            style: .default,
//                                            handler: { [weak self] _ in
//                                                self?.choosePhoto()
//                                            }))
//    present(actionSheet, animated: true)
//}
//
//    func choosePhoto() {
//        UIImagePickerController().sourceType = .photoLibrary
//        present(UIImagePickerController(), animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let url =  info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            print(url)
//        }
//
//        UIImagePickerController().dismiss(animated: true, completion: nil)
//
//    }
//
//    }

