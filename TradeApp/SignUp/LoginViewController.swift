//
//  LoginViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import FirebaseAuth
//import JGProgressHUD

class LoginViewController: UIViewController {
 
//    private let spinner = JGProgressHUD(style: .light )
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.textColor = .black
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()

    private let passwordTextField: UITextField = {
        let field = UITextField()
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
        field.isSecureTextEntry = true
        return field
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 12
        button.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        return button
    }()

    private let newUserRegistrationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Create an Account", for: .normal)
        button.addTarget(self,
                                            action: #selector(didTapNewUserRegistrationButton),
                                            for: .touchUpInside)
        return button
    }()

    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        return header
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "username")
        title = "Login"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        addSubviews()
        view.backgroundColor = .systemBackground

    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(newUserRegistrationButton)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageView = UIImageView(image: UIImage(named: "Logo2"))
        headerView.addSubview(imageView)
//        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = view.bounds
//        imageView.frame = headerView.bounds
        imageView.frame = CGRect(x: headerView.width/2,
                                 y: 0,
                                 width: view.width,
                                 height: view.width)
//        imageView.frame = view.bounds
        
        let fieldWidth = view.width-50
        
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height/2.7)
        
        emailTextField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 20,
            width: fieldWidth,
            height: 55)
        passwordTextField.frame = CGRect(
            x: 25,
            y: emailTextField.bottom + 10,
            width: fieldWidth,
            height: 55)
        loginButton.frame = CGRect(
            x: 25,
            y: passwordTextField.bottom + 20,
            width: fieldWidth,
            height: 55)
        newUserRegistrationButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom + 5,
            width: fieldWidth,
            height: 55)
    }

    
//    @objc private func didTapLoginButton() {
//        passwordTextField.resignFirstResponder() //dismissses keyboard
//        emailTextField.resignFirstResponder()
//
//
//        guard let email = emailTextField.text,
//              let password = passwordTextField.text,
//              !email.isEmpty, !password.isEmpty else {
//            inserteAlert(message: "please fill out all fields")
//            return
//        }
//        if password.count <= 8 {
//            inserteAlert(message: "password incorrect")
//            return
//        }
//
////        DispatchQueue.main.async {
////            self.spinner.show(in: self.view)
////        }
//
//        // email log in
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//
//            guard let authRes = authResult, error == nil else {
//                print("error loging in")
//                self.inserteAlert(message: "email or password is incorrect. Are you registerd?")
//                return
//            }
//            let user = authRes.user
//            print("Logged in user: \(user)")
//
//
//            UserDefaults.standard.set(email, forKey: "email") // save users email adress
//            print(email)
//
//            let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//            DatabaseManager.database.child(safeEmail).child("username").observeSingleEvent(of: .value, with: {
//                snapshot in
//                guard let username = snapshot.value else {
//                    return
//                }
//                UserDefaults.standard.set(username, forKey: "username")
//print(username)
//            })
//            DispatchQueue.main.async {
//                self.spinner.show(in: self.view)
//            }
//            self.navigationController?.dismiss(animated: true, completion: nil)
//            DispatchQueue.main.async {
//                self.spinner.dismiss(animated: true)
//
//            }
//        }
//
//    }
    
    @objc private func didTapLoginButton() {
          emailTextField.resignFirstResponder() //dismissses keyboard
          passwordTextField.resignFirstResponder()
          
          guard let email = emailTextField.text,
                let password = passwordTextField.text,
                !email.isEmpty, !password.isEmpty else {
              inserteAlert(message: "please fill out all fields")
              return
          }
          if password.count <= 8 {
              inserteAlert(message: "password incorrect")
              return
          }
          
//          spinner.show(in: view)
          
          FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
              guard let strongSelf = self else {
                  return
              }
              DispatchQueue.main.async {
//                  strongSelf.spinner.dismiss()
              }
              
              guard let authRes = authResult, error == nil else {
                  print("error loging in")
                  guard let strongSelf = self else{
                      return
                  }
                  strongSelf.inserteAlert(message: "email or password is incorrect. Are you registerd?")
                  return
              }
              let user = authRes.user
              print("Logged in user: \(user)")
              
              let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
              
              UserDefaults.standard.set(email, forKey: "email") // save users email adress
              print(email)

              DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: {
                  snapshot in
                  guard let username = snapshot.value else {
                      return
                  }
                  UserDefaults.standard.set(username, forKey: "username")
  print(username)
              })
              
              strongSelf.navigationController?.dismiss(animated: true, completion: nil)
          })
          
      }
    
//    @objc private func didTapLoginButton() {
//
//        emailTextField.resignFirstResponder() //dismissses keyboard
//        passwordTextField.resignFirstResponder()
//
//        guard let email = emailTextField.text,
//              let password = passwordTextField.text,
//              !email.isEmpty, !password.isEmpty else {
//            inserteAlert(message: "please fill out all fields")
//            return
//        }
//        if password.count <= 8 {
//            inserteAlert(message: "password incorrect")
//            return
//        }
////
////        spinner.show(in: view)
////        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
//            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
////            guard let strongSelf = self else {
////                return
////            }
//            DispatchQueue.main.async {
////                strongSelf.spinner.dismiss()
////                self.spinner.dismiss()
//            }
//            guard let authRes = authResult, error == nil else {
//                print("error loging in")
////                guard let strongSelf = self else{
////                    return
////                }
////                strongSelf.inserteAlert(message: "email or password is incorrect. Are you registerd?")
//                self.inserteAlert(message: "email or password is incorrect. Are you registerd?")
//                return
//            }
//            let user = authRes.user
//            print("Logged in user: \(user)")
//
//            let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//
//            UserDefaults.standard.set(email, forKey: "email") // save users email adress
//            print(email)
//
////            DatabaseManager.database.child("Emails").child(safeEmail).child("username").observeSingleEvent(of: .value, with: {
////                snapshot in
////                guard let username = snapshot.value else {
////                    return
////                }
////                UserDefaults.standard.set(username, forKey: "username")
////print(username)
////            })
//                DatabaseManager.database.child("Emails").child(safeEmail).child("username").getData(completion: { error, snapshot in
//                    guard error == nil else {
//                      print(error!.localizedDescription)
//                      return
//                    }
//                    guard let username = snapshot.value else {
//                        return
//                    }
//                    UserDefaults.standard.set(username, forKey: "username")
//    print(username)
//                })
//
////            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
//
//                self.navigationController?.dismiss(animated: true, completion: nil)
//
//        })
//
//    }

    @objc func didTapNewUserRegistrationButton() {
            print("button clicked")
        let vc = RegistrationViewController()
        vc.title = "Register"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func inserteAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate { // when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            didTapLoginButton()
        }
        return true
    }

}
