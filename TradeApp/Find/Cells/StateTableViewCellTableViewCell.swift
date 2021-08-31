//
//  StateTableViewCellTableViewCell.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

protocol StateTableViewCellDelegate: AnyObject  {
    func StateTableViewCellDidTapGood(_: StateTableViewCell)
    func StateTableViewCellDidTapBad(_: StateTableViewCell)
    func StateTableViewCellDidTapNew(_: StateTableViewCell)
    func StateTableViewCellDidTapOld(_: StateTableViewCell)
    func StateTableViewCellDidTapUsed(_: StateTableViewCell)
    func StateTableViewCellDidTapVeryGoodShape(_: StateTableViewCell)
}

class StateTableViewCell: UITableViewCell {

    weak var delegate: StateTableViewCellDelegate?

    static let identifier = "StateTableViewCell"
    
//    var searchData: SearchData?

    private let stateButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stateButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        stateButton.frame = CGRect(x: 10,
                                y: 30,
                                width: width-20,
                                height: height-10)
    }

    public func configure(with model: StateButtons) {
        self.stateButton.setTitle(model.buttonLabel, for: .normal)
        self.stateButton.backgroundColor = model.backgroundColor
        self.stateButton.setTitleColor(model.textColor, for: .normal)
        self.stateButton.addTarget(self, action: model.action, for: .touchUpInside)
    }

    @objc func didTapNew() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapNew(self)
    }
    @objc func didTapOld() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapOld(self)
    }
    @objc func didTapUsed() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapUsed(self)
    }
    @objc func didTapVeryGoodShape() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapVeryGoodShape(self)
    }
    @objc func didTapGood() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapGood(self)
    }
    @objc func didTapBad() {
        print("Button clicked")
        delegate?.StateTableViewCellDidTapBad(self)
    }
}
    
