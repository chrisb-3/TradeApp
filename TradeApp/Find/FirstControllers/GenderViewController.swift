//
//  GenderViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

struct ArticleButtons {
    let backgroundColor: UIColor
    let textColor: UIColor
    let buttonLabel: String
    let handler: (()-> Void)
    let action: Selector
}

class GenderViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView ()
        tableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.identifier)
        return tableView
    }()
    
    public var genderButtons = [ArticleButtons]()
    
    private func createGenderButtonArray() -> [ArticleButtons] {
        
        var genderButtons: [ArticleButtons] = []
        
        let b1 = ArticleButtons(backgroundColor: .link, textColor: .white, buttonLabel: "female", handler:{[weak self] in
            self?.didTapFemale()
        }, action: #selector(didTapFemale))
        let b2 = ArticleButtons(backgroundColor: .link , textColor: .white, buttonLabel: "male", handler:{[weak self] in
            self?.didTapMale()
        }, action: #selector(didTapMale))
        let b3 = ArticleButtons(backgroundColor: .link, textColor: .white, buttonLabel: "other", handler:{[weak self] in
            self?.didTapOther()
        }, action: #selector(didTapOther))
        let b4 = ArticleButtons(backgroundColor: .link, textColor: .white, buttonLabel: "any", handler:{[weak self] in
            self?.didTapAny()
        }, action: #selector(didTapAny))
        
        
        
        genderButtons.append(b1)
        genderButtons.append(b2)
        genderButtons.append(b3)
        genderButtons.append(b4)
        
        return genderButtons
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        genderButtons = createGenderButtonArray()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
        
    @objc func didTapFemale() {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Female"
        vc.configure(with: "Female")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapMale() {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Male"
        vc.configure(with: "Male")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapOther() {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Other"
        vc.configure(with: "Other")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapAny() {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Any"
        vc.configure(with: "Any")
        navigationController?.pushViewController(vc, animated: true)
    }
  
    
}

extension GenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = genderButtons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableViewCell.identifier) as! GenderTableViewCell
        cell.configure(with: button)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}

extension GenderViewController: GenderTableViewCellDelegate {
    
  
    func GenderTableViewCellDidTapFemale(_: GenderTableViewCell) {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Female"
        vc.configure(with: "Female")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func GenderTableViewCellDidTapMale(_: GenderTableViewCell) {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Male"
        vc.configure(with: "Male")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func GenderTableViewCellDidTapOther(_: GenderTableViewCell) {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Other"
        vc.configure(with: "Other")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func GenderTableViewCellDidTapAny(_: GenderTableViewCell) {
        let vc = GenderSearchResultViewControllerViewController()
        vc.title = "Any"
        vc.configure(with: "Any")
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
