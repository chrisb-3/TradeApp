//
//  EditWishlistViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

class EditWishlistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Wishlist"
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.tableHeaderView = explanationHeader()
        tableView.tableFooterView = textField()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    let explanation: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "In the text box undernath you can add a list of objects that you are looking for. Other users can offer the items you would like and exchange them with one of yours"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkGray
        label.backgroundColor = .systemGray5
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        return label
    }()
    
    private let wishField: UITextView = {
        let field = UITextView()
        field.returnKeyType = .next
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.black.cgColor
        
        
        let email = UserDefaults.standard.value(forKey: "email") as? String
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email!)
        
        DatabaseManager.database.child("Emails").child(safeEmail).child("Wishlist").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let listResult = snapshot.value as? String else {
                return
            }
            field.text = listResult
        })
        return field
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        return tableView
    }()
    
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    private func explanationHeader()-> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4.5).integral)
        
        
        header.addSubview(explanation)
        
        
        explanation.layer.masksToBounds = true
        explanation.tintColor = .label
        explanation.frame = CGRect(x: 25,
                                   y: 20,
                                   width: view.width-50,
                                   height: view.height/5)
        return header
    }
    private func textField()-> UIView {
        let descriptiontextFields = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height).integral)
        
        ///text fields
        descriptiontextFields.addSubview(wishField)
        wishField.layer.masksToBounds = true
        wishField.layer.borderWidth = 1
        wishField.layer.borderColor = UIColor.black.cgColor
        wishField.frame = CGRect(x: 20,
                                 y: 0,
                                 width: view.width-50,
                                 height: view.height/1.5)
        wishField.font = .systemFont(ofSize: 20, weight: .regular)
        return descriptiontextFields
    }
    
    @objc func didTapDone() {
        guard
            let wishList = wishField.text else {
                return
            }
        
        //save to database
        storeWishlistToFirebase(with: wishList)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel(){
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension EditWishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier) as! EmptyTableViewCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        }
        return view.height/2
    }
    
}

