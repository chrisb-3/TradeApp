//
//  ArticlesTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
// this cell displayes the garments buttons and the color buttons

protocol ArticlesTableViewCellDelegate: AnyObject  {
    func ArticlesTableViewCellDidTapjeans(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapshirt(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapcoat(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapjacket(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapdress(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapskirt(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapTshirt(_: ArticlesTableViewCell)
    func ArticlesTableViewCellDidTapPants(_: ArticlesTableViewCell)
    
    func ArticlesTableViewCellDidTaptBlue(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptPink(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptYellow(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptOrange(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptRed(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptGreen(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptBrown(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptWhite(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptBlack(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptPurple(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptMix(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptGray(_:ArticlesTableViewCell)
    func ArticlesTableViewCellDidTaptOther(_:ArticlesTableViewCell)
}

class ArticlesTableViewCell: UITableViewCell {
    
    weak var delegate: ArticlesTableViewCellDelegate?
    
    static let identifier = "ArticlesTableViewCell"
    
    private let articlesButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(articlesButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        articlesButton.frame = CGRect(x: 10,
                                      y: 30,
                                      width: width-20,
                                      height: height-10)}
    
    public func configure(with model: ArticleButtons) {
        self.articlesButton.setTitle(model.buttonLabel, for: .normal)
        self.articlesButton.backgroundColor = model.backgroundColor
        self.articlesButton.setTitleColor(model.textColor, for: .normal)
        self.articlesButton.addTarget(self, action: model.action, for: .touchUpInside)
    }
    
    ///garments
    @objc private func didTapjeans() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Jeans"
        vc.configure(with: "jeans")
        delegate?.ArticlesTableViewCellDidTapjeans(self)
    }
    @objc private func didTapcoat() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Coats"
        vc.configure(with: "coat")
        delegate?.ArticlesTableViewCellDidTapcoat(self)
    }
    @objc private func didTapjacket() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Jackets"
        vc.configure(with: "jacket")
        delegate?.ArticlesTableViewCellDidTapjacket(self)
    }
    @objc private func didTapdress() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Dress"
        vc.configure(with: "dress")
        delegate?.ArticlesTableViewCellDidTapdress(self)
    }
    @objc private func didTapTshirt() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "T-shirts"
        vc.configure(with: "t-shirt")
        delegate?.ArticlesTableViewCellDidTapTshirt(self)
    }
    @objc private func didTapshirt() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Shirts"
        vc.configure(with: "shirt")
        delegate?.ArticlesTableViewCellDidTapshirt(self)
    }
    @objc private func didTapskirt() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Skirts"
        vc.configure(with: "skirt")
        delegate?.ArticlesTableViewCellDidTapskirt(self)
    }
    @objc private func didTapPants() {
        print("Button clicked")
        let vc = GarmentsSearchResultViewController()
        vc.title = "Pants"
        vc.configure(with: "pants")
        delegate?.ArticlesTableViewCellDidTapPants(self)
    }
    
    /// colors
    @objc func didTapBlue() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptBlue(self)
    }
    @objc func didTapPurple() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptPurple(self)
    }
    @objc func didTapPink() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptPink(self)
    }
    @objc func didTapYellow() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptYellow(self)
    }
    @objc func didTapOrange() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptOrange(self)
    }
    @objc func didTapRed(){
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptRed(self)
    }
    @objc func didTapGreen() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptGreen(self)
    }
    @objc func didTapBrown() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptBrown(self)
    }
    @objc func didTapWhite() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptWhite(self)
    }
    @objc func didTapBlack() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptBlack(self)
    }
    @objc func didTapMix() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptMix(self)
    }
    @objc func didTapGray() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptGray(self)
    }
    @objc func didTapOther() {
        print("Button clicked")
        delegate?.ArticlesTableViewCellDidTaptOther(self)
    }
}
