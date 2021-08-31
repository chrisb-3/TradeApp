//
//  FindViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

struct Buttons {
    let backgroundImage: UIImage
    let buttonLabel: String
    let handler: (()-> Void)
    let action: Selector
}




class FindViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView ()
        tableView.register(FindTableViewCell.self, forCellReuseIdentifier: FindTableViewCell.identifier)
        return tableView
    }()
    
    
      
    
    public var buttons = [Buttons]()
    
    
    private func createButtonArray() -> [Buttons] {
        
        var findButtons: [Buttons] = []
        let yellow = UIImage(named: "yellow")!
        let blue = UIImage(named: "blue")!
        let brown = UIImage(named: "brown")!
        let pink = UIImage(named: "pink")!
        let red = UIImage(named: "red")!
        let gray = UIImage(named: "gray")!
        let users = UIImage(named: "people")!

        let b1 = Buttons(backgroundImage: yellow, buttonLabel: "Garments",
                         handler: {[weak self] in
            self?.didTapGarments()
        }, action: #selector(didTapGarments))
        
        let b2 = Buttons(backgroundImage: blue, buttonLabel: "Gender"
                         , handler: {[weak self] in
            self?.didTapGender()
        }, action: #selector(didTapGender))
        
        let b3 = Buttons(backgroundImage: pink, buttonLabel: "Color"
                         , handler: {[weak self] in
            self?.didTapColor()
        }, action: #selector(didTapColor))

        let b4 = Buttons(backgroundImage: red, buttonLabel: "Item State"
                         , handler: {[weak self] in
            self?.didTapItemState()
        }, action: #selector(didTapItemState))

        let b5 = Buttons(backgroundImage: users, buttonLabel: "Users",
                         handler: {[weak self] in
            self?.didTapUsers()
        }, action: #selector(didTapUsers))
        
        let b6 = Buttons(backgroundImage: brown, buttonLabel: "See all"
                         , handler: {[weak self] in
            self?.didTapAll()
        }, action: #selector(didTapAll))
        
    
        findButtons.append(b1)
        findButtons.append(b2)
        findButtons.append(b3)
        findButtons.append(b4)
        findButtons.append(b5)
        findButtons.append(b6)
       
        return findButtons
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find"
//        configureNavigationBar()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        buttons = createButtonArray()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

        
    }


    @objc func didTapGarments() {
        let vc = GarmentsViewController()
        vc.title = "Garments"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapColor() {
        let vc = ColorsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapGender() {
        let vc = GenderViewController()
        vc.title = "Gender"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapItemState() {
        let vc = StateViewController()
        vc.title = "Item State"
        navigationController?.pushViewController(vc, animated: true)
    }


    @objc func didTapAll() {
        let vc = HomeViewController()
        vc.title = "All"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapUsers() {
        let vc = UsersViewController()
        vc.title = "Search Results"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
        
    }
    

    
    
}

extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = buttons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FindTableViewCell.identifier) as! FindTableViewCell
        cell.configure(with: button)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = buttons[indexPath.row]
        model.handler()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension FindViewController: FindTableViewCellDelegate {
   
    
    
    func FindViewDidTapUsers(_: FindTableViewCell) {
        let vc = UsersViewController()
        vc.title = "Search Results"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
        
    }
    func FindViewDidTapGarments(_: FindTableViewCell) {
        let vc = GarmentsViewController()
        vc.title = "Garments"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func FindViewDidTapColor(_: FindTableViewCell) {
        let vc = ColorsViewController()
        vc.title = "Colors"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func FindViewDidTapGender(_: FindTableViewCell) {
        let vc = GenderViewController()
        vc.title = "Gender"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

    func FindViewDidTapItemState(_: FindTableViewCell) {
        let vc = StateViewController()
        vc.title = "Item State"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func FindViewDidTapAll(_: FindTableViewCell) {
        let vc = HomeViewController()
        vc.title = "All"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

