//
//  SettingsViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
import FirebaseAuth

struct SettingCellModel {
    let title: String
    let handler: (()-> Void) // Void means it doesn't return a value
}

/// shows user settings
final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    
    private func configureModels(){
        
        data.append([
        SettingCellModel(title: "Edit Wishlist") {[weak self] in
            self?.didTapEditWishlist()
        }
        ])
                        
        data.append([
            SettingCellModel(title: "Edit Profile") {[weak self] in
                self?.didTapEditProfile()
            },
            
            SettingCellModel(title: "App Information") {[weak self] in
                self?.didTapAppInfo()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Logout", handler: {[weak self] in
                self?.didTapLogout()
            }
            )
        ])
    }
    
    private func didTapLogout() {
        let actionSheet = UIAlertController(title: "Log Out",
                                            message: "Do you want to log out?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive, //red
                                            handler: { [weak self] _ in
                                                guard let strongSelf = self else
                                                {
                                                    return
                                                }
                                                UserDefaults.standard.set(nil, forKey: "email")
                                                UserDefaults.standard.set(nil, forKey: "username")
                                                let email =  UserDefaults.standard.value(forKey: "email") as? String
                                                print(email)
                                                AuthManager.shared.logOut(completion: { success in
                                                    DispatchQueue.main.async {
                                                        if success {
                                                            let vc = LoginViewController()
                                                            let nav = UINavigationController(rootViewController: vc)
                                                            nav.modalPresentationStyle = .fullScreen
                                                            strongSelf.present(nav, animated: true)
                                                        }
                                                        else {
                                                            print("could not log out user")
                                                        }
                                                    }
                                                    
                                                })
                                                
                                            }))
        present(actionSheet, animated: true)
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func didTapAppInfo() {

    }
    
    private func didTapEditWishlist() {
        let vc = EditWishlistViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row] // find which box in what section and what row
        model.handler() // at section x and row y do what is coded for handler
    }


}
