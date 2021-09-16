//
//  ExtraRecomendTableViewCell.swift
//  TradeApp
//
//  Created by Christina Braun on 15.09.21.
//


import UIKit

protocol ExtraRecomendTableViewCellDelegate: AnyObject  {
    func ExtraRecomendTableViewCellTap(_: ExtraRecomendTableViewCell)
}

class ExtraRecomendTableViewCell: UITableViewCell {
    
    static let identifier = "ExtraRecomendTableViewCell"

    weak var delegate: ExtraRecomendTableViewCellDelegate?
    
    private let Button: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .secondaryLabel
        button.setTitle("See More", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(Button)
            buttonAction()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        Button.frame = CGRect(x: 10,
                              y: 30,
                              width: width-40,
                              height: height/2)
    }
    private func buttonAction() {

        Button.addTarget(self, action: #selector(didTapExtra), for: .touchUpInside)
    }

    @objc func didTapExtra() {
        print("Button clicked")
        delegate?.ExtraRecomendTableViewCellTap(self)
    }
}


