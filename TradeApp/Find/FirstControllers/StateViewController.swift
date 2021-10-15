//
//  StateViewControllerViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit


class StateViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let tableView = UITableView ()
        tableView.register(StateTableViewCell.self, forCellReuseIdentifier: StateTableViewCell.identifier)
        return tableView
    }()
    
    public var stateButtons = [ArticleButtons]()
    
    private func createButtonArray() -> [ArticleButtons] {
        
        var stateButtons: [ArticleButtons] = []
        
    
        let b1 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "good", handler:{[weak self] in
            self?.didTapGood()
        }, action: #selector(didTapGood))
        let b2 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "bad", handler:{[weak self] in
            self?.didTapBad()
        }, action: #selector(didTapBad))
        let b3 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "new", handler:{[weak self] in
            self?.didTapNew()
        }, action: #selector(didTapNew))
        let b4 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "old", handler:{[weak self] in
            self?.didTapOld()
        }, action: #selector(didTapOld))
//        let b5 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "used", handler:{[weak self] in
//            self?.didTapUsed()
//        }, action: #selector(didTapUsed))
        let b6 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "very goog shape", handler:{[weak self] in
            self?.didTapVeryGoodShape()
        }, action: #selector(didTapVeryGoodShape))
        
        
        stateButtons.append(b1)
        stateButtons.append(b2)
        stateButtons.append(b3)
        stateButtons.append(b4)
//        stateButtons.append(b5)
        stateButtons.append(b6)
        
        return stateButtons
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        stateButtons = createButtonArray()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
        
    @objc func didTapGood() {
        let vc = StateResultViewController()
        vc.title = "Good"
        vc.configure(with: "Good")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapBad() {
        let vc = StateResultViewController()
        vc.title = "Bad"
        vc.configure(with: "Bad")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapNew() {
        let vc = StateResultViewController()
        vc.title = "New"
        vc.configure(with: "New")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapOld() {
        let vc = StateResultViewController()
        vc.title = "Old"
        vc.configure(with: "Old")
        navigationController?.pushViewController(vc, animated: true)
    }
//    @objc func didTapUsed() {
//        let vc = StateResultViewController()
//        vc.title = "Used"
//        vc.configure(with: "Used")
//        navigationController?.pushViewController(vc, animated: true)
//    }
    @objc func didTapVeryGoodShape() {
        let vc = StateResultViewController()
        vc.title = "Very good shape"
        vc.configure(with: "very_good_shape")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = stateButtons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StateTableViewCell.identifier) as! StateTableViewCell
        cell.configure(with: button)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}

extension StateViewController: StateTableViewCellDelegate {
    
    func StateTableViewCellDidTapGood(_: StateTableViewCell) {
        let vc = StateResultViewController()
        vc.title = "Good"
        vc.configure(with: "Good")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func StateTableViewCellDidTapBad(_: StateTableViewCell) {
        let vc = StateResultViewController()
        vc.title = "Bad"
        vc.configure(with: "Bad")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func StateTableViewCellDidTapNew(_: StateTableViewCell) {
        let vc = StateResultViewController()
        vc.title = "New"
        vc.configure(with: "New")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func StateTableViewCellDidTapOld(_: StateTableViewCell) {
        let vc = StateResultViewController()
        vc.title = "Old"
        vc.configure(with: "Old")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    func StateTableViewCellDidTapUsed(_: StateTableViewCell) {
//        let vc = StateResultViewController()
//        vc.title = "Used"
//        vc.configure(with: "Used")
//        navigationController?.pushViewController(vc, animated: true)
//        
//    }
    
    func StateTableViewCellDidTapVeryGoodShape(_: StateTableViewCell) {
        let vc = StateResultViewController()
        vc.title = "Very good shape"
        vc.configure(with: "very_good_shape")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
