//
//  ColorsViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit

class ColorsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView ()
        tableView.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return tableView
    }()
    
    public var colorButtons = [ArticleButtons]()
    private func createColorButtonArray() -> [ArticleButtons] {
        
        var colorButtons: [ArticleButtons] = []
        
        let b1 = ArticleButtons(backgroundColor: .systemYellow , textColor: .white, buttonLabel: "yellow", handler:{[weak self] in
            self?.didTapYellow()
        }, action: #selector(didTapYellow))
        let b2 = ArticleButtons(backgroundColor: .systemOrange, textColor: .white, buttonLabel: "orange", handler:{[weak self] in
            self?.didTapOrange()
        }, action: #selector(didTapOrange))
        let b3 = ArticleButtons(backgroundColor: .systemRed, textColor: .white, buttonLabel: "red", handler:{[weak self] in
            self?.didTapRed()
        }, action: #selector(didTapRed))
        let b4 = ArticleButtons(backgroundColor: .systemPink, textColor: .white, buttonLabel: "pink", handler:{[weak self] in
            self?.didTapPink()
        }, action: #selector(didTapPink))
        let b5 = ArticleButtons(backgroundColor: .systemPurple, textColor: .white, buttonLabel: "purple", handler:{[weak self] in
            self?.didTapPurple()
        }, action: #selector(didTapPurple))
        let b6 = ArticleButtons(backgroundColor: .systemBlue, textColor: .white, buttonLabel: "blue", handler:{[weak self] in
            self?.didTapBlue()
        }, action: #selector(didTapBlue))
        let b7 = ArticleButtons(backgroundColor: .systemGreen, textColor: .white, buttonLabel: "green", handler:{[weak self] in
            self?.didTapGreen()
        }, action: #selector(didTapGreen))
        let b8 = ArticleButtons(backgroundColor: .brown, textColor: .white, buttonLabel: "brown", handler:{[weak self] in
            self?.didTapBrown()
        }, action: #selector(didTapBrown))
        let b9 = ArticleButtons(backgroundColor: .black, textColor: .white, buttonLabel: "black", handler:{[weak self] in
            self?.didTapBlack()
        }, action: #selector(didTapBlack))
        let b10 = ArticleButtons(backgroundColor: .secondarySystemFill, textColor: .secondaryLabel, buttonLabel: "white", handler:{[weak self] in
            self?.didTapWhite()
        }, action: #selector(didTapWhite))
        let b11 = ArticleButtons(backgroundColor: .gray, textColor: .white, buttonLabel: "gray", handler:{[weak self] in
            self?.didTapGray()
        }, action: #selector(didTapGray))
        let b12 = ArticleButtons(backgroundColor: .purple, textColor: .white, buttonLabel: "Mix", handler:{[weak self] in
            self?.didTapMix()
        }, action: #selector(didTapMix))
        let b13 = ArticleButtons(backgroundColor: .systemIndigo, textColor: .white, buttonLabel: "other", handler:{[weak self] in
            self?.didTapOther()
        }, action: #selector(didTapOther))
        
        colorButtons.append(b1)
        colorButtons.append(b2)
        colorButtons.append(b3)
        colorButtons.append(b4)
        colorButtons.append(b5)
        colorButtons.append(b6)
        colorButtons.append(b7)
        colorButtons.append(b8)
        colorButtons.append(b9)
        colorButtons.append(b10)
        colorButtons.append(b11)
        colorButtons.append(b12)
        colorButtons.append(b13)
        return colorButtons
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        colorButtons = createColorButtonArray()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.separatorColor = .clear
    }
    
    @objc func didTapBlue() {
        let vc = ColorsResultsViewController()
        vc.title = "Blue"
        vc.configure(with: "Blue")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapYellow() {
        let vc = ColorsResultsViewController()
        vc.title = "Yellow"
        vc.configure(with: "Yellow")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapOrange() {
        let vc = ColorsResultsViewController()
        vc.title = "Orange"
        vc.configure(with: "Orange")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapRed() {
        let vc = ColorsResultsViewController()
        vc.title = "Red"
        vc.configure(with: "Red")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapPurple() {
        let vc = ColorsResultsViewController()
        vc.title = "Purple"
        vc.configure(with: "Purple")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapPink() {
        let vc = ColorsResultsViewController()
        vc.title = "Pink"
        vc.configure(with: "Pink")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapGreen() {
        let vc = ColorsResultsViewController()
        vc.title = "Green"
        vc.configure(with: "Green")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapBrown() {
        let vc = ColorsResultsViewController()
        vc.title = "Brown"
        vc.configure(with: "Brown")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapWhite() {
        let vc = ColorsResultsViewController()
        vc.title = "White"
        vc.configure(with: "White")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapBlack() {
        let vc = ColorsResultsViewController()
        vc.title = "Black"
        vc.configure(with: "Black")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapGray() {
        let vc = ColorsResultsViewController()
        vc.title = "Gray"
        vc.configure(with: "Gray")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapMix() {
        let vc = ColorsResultsViewController()
        vc.title = "Mix"
        vc.configure(with: "Mix")
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapOther() {
        let vc = ColorsResultsViewController()
        vc.title = "Other"
        vc.configure(with: "Other")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ColorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = colorButtons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
        cell.configure(with: button)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ColorsViewController: ArticlesTableViewCellDelegate {
    
    
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
    func ArticlesTableViewCellDidTaptGray(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Gray"
        vc.configure(with: "Gray")
        navigationController?.pushViewController(vc, animated: true)
    }
    func ArticlesTableViewCellDidTaptMix(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Mix"
        vc.configure(with: "Mix")
        navigationController?.pushViewController(vc, animated: true)
    }
    func ArticlesTableViewCellDidTaptOther(_: ArticlesTableViewCell) {
        let vc = ColorsResultsViewController()
        vc.title = "Other"
        vc.configure(with: "Other")
        navigationController?.pushViewController(vc, animated: true)
    }
    func ArticlesTableViewCellDidTapjeans(_: ArticlesTableViewCell) {
        let vc = GarmentsSearchResultViewController()
        vc.title = "Jeans"
        vc.configure(with: "jeans")
        navigationController?.pushViewController(vc, animated: true)
    }
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
        vc.configure(with: "Dress")
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
}
