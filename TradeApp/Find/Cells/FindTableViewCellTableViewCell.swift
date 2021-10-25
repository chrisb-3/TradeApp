//
//  FindTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
/// this cell displayes the find buttons

protocol FindTableViewCellDelegate: AnyObject  {
    func FindViewDidTapGarments(_: FindTableViewCell)
    func FindViewDidTapColor(_: FindTableViewCell)
    func FindViewDidTapGender(_: FindTableViewCell)
    func FindViewDidTapItemState(_: FindTableViewCell)
    func FindViewDidTapAll(_: FindTableViewCell)
    func FindViewDidTapUsers(_: FindTableViewCell)
    
}
class FindTableViewCell: UITableViewCell {
    weak var delegate: FindTableViewCellDelegate?
    static let identifier = "FindTableViewCell"
    
    private let mainButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mainButton.frame = CGRect(x: 10,
                                  y: 30,
                                  width: width-20,
                                  height: height-10)
    }
    
    
    public func configure(with model: Buttons) {
        self.mainButton.setTitle(model.buttonLabel, for: .normal)
        self.mainButton.setBackgroundImage(model.backgroundImage, for: .normal)
        self.mainButton.addTarget(self, action: model.action, for: .touchUpInside)
    }
    
    @objc private func didTapGarments() {
        print("Button clicked")
        delegate?.FindViewDidTapGarments(self)
    }
    @objc private func didTapColor() {
        print("Button clicked")
        delegate?.FindViewDidTapColor(self)
    }
    @objc private func didTapGender() {
        print("Button clicked")
        delegate?.FindViewDidTapGender(self)
    }
    @objc private func didTapItemState() {
        print("Button clicked")
        delegate?.FindViewDidTapItemState(self)
    }
    @objc private func didTapAll() {
        print("Button clicked")
        delegate?.FindViewDidTapAll(self)
    }
    @objc private func didTapUsers() {
        print("Button clicked")
        delegate?.FindViewDidTapUsers(self)
    }
}

