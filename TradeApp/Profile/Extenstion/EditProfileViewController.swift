//
//  EditProfileViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    
    private let userProfileImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    private let choosePhotoLabel: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("Tap on the profile image to edit it", for: .normal)
        return button
    }()

   

    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.systemTeal.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        choosePhotoLabel.addTarget(self,
                                   action: #selector(editProfileImage),
                                   for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        
        imagePickerController.delegate = self
        addSubviews()
        view.backgroundColor = .systemBackground
        
        userProfileImage.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(editProfileImage))
        
        userProfileImage.addGestureRecognizer(gesture)
        loadImage()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let fieldWidth = view.width-50
        
        userProfileImage.frame = CGRect(
            x: view.width/2-100,
            y: 150,
            width: view.width/2,
            height: view.width/2)
        userProfileImage.layer.cornerRadius = userProfileImage.height/2
        
        choosePhotoLabel.frame = CGRect(
            x: 25,
            y: userProfileImage.bottom + 20,
            width: fieldWidth,
            height: 10)
        
        doneButton.frame = CGRect(
            x: 25,
            y: choosePhotoLabel.bottom + 30,
            width: fieldWidth,
            height: 55)
    }
    
    private func addSubviews() {
        view.addSubview(userProfileImage)
        view.addSubview(choosePhotoLabel)
        view.addSubview(doneButton)
    }
    
    private func loadImage() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        
        let path = "images/\(safeEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):

                DispatchQueue.main.async {
                    self.userProfileImage.sd_setImage(with: url)
                }
            case .failure(let error):
                print("failed to get url: \(error)")
            }
        })
        
        
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    
    }
    
    @objc func didTapDone() {
        
        let name = UserDefaults.standard.value(forKey: "username")
        let email = UserDefaults.standard.value(forKey: "email")
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email as! String)
        
        guard let image = self.userProfileImage.image, let
                data = image.pngData() else {
            return
        }
        let appUser = AppUser(userName: name as! String,
                              emailAdress: safeEmail)
        let fileName = appUser.profilePictureFileName

        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
            switch result {
            // either failure or success
            case.success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                print(downloadUrl)

            case.failure(let error):
                print("Storage manage error: \(error)")
            }
        })
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func didTapCancel() {

        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func editProfileImage() {
        presentPhotoActionSheet()
    }
    
    var imagePickerController = UIImagePickerController()
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Do you want to change your profile Image?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.choosePhoto()
                                            }))
    present(actionSheet, animated: true)
}
    func choosePhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true // frame to crop image

        present(vc, animated: true)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.userProfileImage.image = selectedImage
        choosePhotoLabel.setTitle("eddit profile image", for: .normal)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // when cancell is clicked
        picker.dismiss(animated: true, completion: nil)
    }
}




