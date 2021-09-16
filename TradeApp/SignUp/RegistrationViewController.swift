//
//  RegistrationViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .light)
        
    private let userProfileImage: UIImageView = {
        let image = UIImageView()
        image.image =  UIImage(systemName: "person.circle")
        image.tintColor = .gray
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    private let choosePhotoLabel: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("choose your profile photo", for: .normal)
        return button
    }()

    private let userNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.placeholder = "Email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.textContentType = .none
        field.placeholder = "Password"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.isSecureTextEntry = true // makes the text show up as dots
        return field
    }()

    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.systemGreen.cgColor
        button.layer.cornerRadius = 12
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.frame = view.bounds
        
        
        UserDefaults.standard.set(nil, forKey: "email") // save users email adress
        UserDefaults.standard.set(nil, forKey: "username")

        registrationButton.addTarget(self,
                              action: #selector(didTapRegistrationButton),
                              for: .touchUpInside)
        choosePhotoLabel.addTarget(self,
                                   action: #selector(didTapAddProfilePicture),
                                   for: .touchUpInside)
        
        imagePickerController.delegate = self
        emailField.delegate = self
        userNameField.delegate = self
        passwordTextField.delegate = self
        addSubviews()
        view.backgroundColor = .systemBackground
        
        userProfileImage.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddProfilePicture))
        
        userProfileImage.addGestureRecognizer(gesture)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let fieldWidth = view.width-50
        
        userProfileImage.frame = CGRect(
            x:view.width/2-(view.width/2.5)/2,
            y: view.height/10+5,
            width: view.width/2.5,
            height: view.width/2.5)
        userProfileImage.layer.cornerRadius = userProfileImage.height/2
        
        choosePhotoLabel.frame = CGRect(
            x: 25,
            y: userProfileImage.bottom + 5,
            width: fieldWidth,
            height: 10)
        userNameField.frame = CGRect(
            x: 25,
            y: choosePhotoLabel.bottom + 20,
            width: fieldWidth,
            height: 55)
        emailField.frame = CGRect(
            x: 25,
            y: userNameField.bottom + 10,
            width: fieldWidth,
            height: 55)
        passwordTextField.frame = CGRect(
            x: 25,
            y: emailField.bottom + 10,
            width: fieldWidth,
            height: 55)
        registrationButton.frame = CGRect(
            x: 25,
            y: passwordTextField.bottom + 10,
            width: fieldWidth,
            height: 55)
    }
    
    
    private func addSubviews() {        
        view.addSubview(userProfileImage)
        view.addSubview(choosePhotoLabel)
        view.addSubview(userNameField)
        view.addSubview(emailField)
        view.addSubview(passwordTextField)
        view.addSubview(registrationButton)
    }
    
    @objc private func didTapRegistrationButton() {
        
        userNameField.resignFirstResponder() // hide the keyboard
        emailField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    
        
        guard let username = userNameField.text,
        let email = emailField.text,
        let password = passwordTextField.text,
        !username.isEmpty, !email.isEmpty, !password.isEmpty
        else {
            registrationAlert(message: "Please fill out all fields")
            return
        }
        guard let password = passwordTextField.text, password.count >= 8 else {
            registrationAlert(message: "The password must contain more than 8 charakters")
            return
        }
        
        spinner.show(in: view)
        
        // Firebase Registration
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
              return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                let alert = UIAlertController(title: "registration Error", message: "A user account to this email already exists", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                strongSelf.present(alert, animated: true)
                // user already exists. Show error
                print("user exists")
                return
            }



        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult,error in // the user gets registerd with an email and a password
            // data inserted into firebase Authentications
            guard error == nil else {
                let alert = UIAlertController(title: "registration Error", message: "email is already used or incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                strongSelf.present(alert, animated: true)
                print("error creating user")
                return
            }


            let appUser = AppUser(userName: username,
                                  emailAdress: email
//                                  profileImage: imageURL
            )

            DatabaseManager.shared.addUserDataToFirebase(with: appUser, completion: {success in
                if success {
                    guard let image = strongSelf.userProfileImage.image, let data = image.pngData() else {
                        return
                    }

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

                }
            })
        

            UserDefaults.standard.set(email, forKey: "email") // save users email adress
            UserDefaults.standard.set(username, forKey: "username")
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    private func registrationAlert (message: String) {
        let alert = UIAlertController(title: "Registration Error", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc func didTapAddProfilePicture() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "select a profile Image", preferredStyle: .actionSheet)
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
    
    var imagePickerController = UIImagePickerController()
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordTextField.becomeFirstResponder()
        }
        
        else if textField == passwordTextField {
            didTapRegistrationButton()
        }
        return true
    }
    
    
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        choosePhotoLabel.setTitle("edit profile image", for: .normal)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // when cancel is clicked
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
