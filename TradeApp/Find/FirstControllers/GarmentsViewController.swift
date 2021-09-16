//
//  GarmentsViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

class GarmentsViewController: UIViewController {


        private let tableView: UITableView = {
            let tableView = UITableView ()
            tableView.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
            return tableView
        }()
        
        
        public var articleButtons = [ArticleButtons]()
        
        private func createButtonArray() -> [ArticleButtons] {
            
            var findButtons: [ArticleButtons] = []
            let b1 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white , buttonLabel: "jeans", handler: {[weak self] in
                self?.didTapjeans()
            },action: #selector(didTapjeans))
          
            let b2 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "Tshirt", handler: {[weak self] in
                self?.didTapTshirt()
            }, action: #selector(didTapTshirt))
            
           
            let b3 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "coat", handler: {[weak self] in
                self?.didTapcoat()
            }, action: #selector(didTapcoat))
            
           
            let b4 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "shirt", handler: {[weak self] in
                self?.didTapshirt()
            }, action: #selector(didTapshirt))
           
            let b5 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "dress", handler: {[weak self] in
                self?.didTapdress()
            }, action: #selector(didTapdress))
            
            let b6 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "skirt", handler: {[weak self] in
                self?.didTapskirt()
            }, action: #selector(didTapskirt))
            
            let b7 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "jacket", handler: {[weak self] in
                self?.didTapjacket()
            }, action: #selector(didTapjacket))
            
            let b8 = ArticleButtons(backgroundColor: .systemYellow, textColor: .white, buttonLabel: "pants", handler: {[weak self] in
                self?.didTapPants()
            }, action: #selector(didTapPants))

            findButtons.append(b1)
            findButtons.append(b2)
            findButtons.append(b3)
            findButtons.append(b4)
            findButtons.append(b5)
            findButtons.append(b6)
            findButtons.append(b7)
            findButtons.append(b8)

            return findButtons
        }
    
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            articleButtons = createButtonArray()
            
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableView.frame = view.bounds

    //
    //
        }
        
        @objc func didTapjeans() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Jeans"
            vc.configure(with: "jeans")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func didTapTshirt() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "T-shirts"
            vc.configure(with: "t-shirt")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func didTapshirt() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Shirts"
            vc.configure(with: "shirt")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func didTapdress() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Dress"
            vc.configure(with: "dress")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func didTapskirt() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Skirts"
            vc.configure(with: "skirt")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func didTapcoat() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Coats"
            vc.configure(with: "coat")
            navigationController?.pushViewController(vc, animated: true)
        }
        @objc func didTapjacket() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Jackets"
            vc.configure(with: "jacket")
            navigationController?.pushViewController(vc, animated: true)
        }
        @objc func didTapPants() {
            let vc = GarmentsSearchResultViewController()
            vc.title = "Pants"
            vc.configure(with: "pants")
            navigationController?.pushViewController(vc, animated: true)
    }
    }

    extension GarmentsViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articleButtons.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
            let button = articleButtons[indexPath.row]
            cell.configure(with: button)
            cell.delegate = self
    //        cell.didTapSearchButton(with: button.vc)
            
    //        cell.searchData = data
            return cell
        }
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            let model = articleButtons[indexPath.row]
//            model.handler()
//        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    }

extension GarmentsViewController: ArticlesTableViewCellDelegate {
    func ArticlesTableViewCellDidTapTshirt(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "T-shirts"
        vc.configure(with: "t-shirt")
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    func ArticlesTableViewCellDidTapshirt(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Shirts"
        vc.configure(with: "shirt")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    ///Garments
    func ArticlesTableViewCellDidTapjeans(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Jeans"
        vc.configure(with: "jeans")
        navigationController?.pushViewController(vc, animated: true)
    }
        
    func ArticlesTableViewCellDidTapcoat(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Coats"
        vc.configure(with: "coat")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTapjacket(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Jackets"
        vc.configure(with: "jacket")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTapdress(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Dresses"
        vc.configure(with: "dress")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTapskirt(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Skirts"
        vc.configure(with: "skirt")
        navigationController?.pushViewController(vc, animated: true)
    }
    func ArticlesTableViewCellDidTapPants(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Pants"
        vc.configure(with: "pants")
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    ///colors
    func ArticlesTableViewCellDidTaptPurple(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Purple"
        vc.configure(with: "Purple")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptBlue(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Blue"
        vc.configure(with: "Blue")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptPink(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Pink"
        vc.configure(with: "Pink")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptYellow(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Yellow"
        vc.configure(with: "Yellow")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptOrange(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Orange"
        vc.configure(with: "Orange")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptRed(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Red"
        vc.configure(with: "Red")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptGreen(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Green"
        vc.configure(with: "Green")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptBrown(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Brown"
        vc.configure(with: "Brown")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptWhite(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "White"
        vc.configure(with: "White")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ArticlesTableViewCellDidTaptBlack(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Black"
        vc.configure(with: "Black")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
