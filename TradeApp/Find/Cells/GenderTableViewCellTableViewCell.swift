//
//  GenderTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

protocol GenderTableViewCellDelegate: AnyObject  {
    func GenderTableViewCellDidTapFemale(_: GenderTableViewCell)
    func GenderTableViewCellDidTapMale(_: GenderTableViewCell)
    func GenderTableViewCellDidTapOther(_: GenderTableViewCell)
    func GenderTableViewCellDidTapAny(_: GenderTableViewCell)
}

class GenderTableViewCell: UITableViewCell {
    
    weak var delegate: GenderTableViewCellDelegate?
    
    static let identifier = "GenderTableViewCell"
    
    private let genderButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(genderButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        genderButton.frame = CGRect(x: 10,
                                    y: 30,
                                    width: width-20,
                                    height: height-10)
    }
    
    public func configure(with model: ArticleButtons) {
        self.genderButton.setTitle(model.buttonLabel, for: .normal)
        self.genderButton.backgroundColor = model.backgroundColor
        self.genderButton.setTitleColor(model.textColor, for: .normal)
        self.genderButton.addTarget(self, action: model.action, for: .touchUpInside)
    }
    
    @objc func didTapFemale() {
        print("Button clicked")
        delegate?.GenderTableViewCellDidTapFemale(self)
    }
    @objc func didTapMale() {
        print("Button clicked")
        delegate?.GenderTableViewCellDidTapMale(self)
    }
    @objc func didTapOther() {
        print("Button clicked")
        delegate?.GenderTableViewCellDidTapOther(self)
    }
    @objc func didTapAny() {
        print("Button clicked")
        delegate?.GenderTableViewCellDidTapAny(self)
    }
}
    
