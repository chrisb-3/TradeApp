//
//  WishlistButtonCollectionReusableView.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

protocol WishlistButtonCollectionReusableViewDelegate: AnyObject {
    func DidTapWishlist(_header: WishlistButtonCollectionReusableView)
}

class WishlistButtonCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "WishlistButtonCollectionReusableView"
    
    public weak var delegate: WishlistButtonCollectionReusableViewDelegate?
    
    private let whishList: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .darkText
        button.backgroundColor = .darkGray
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Wish List", for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        whishList.frame = CGRect(x: 10,
                                 y: 20,
                                 width: width-20,
                                 height: width/6)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whishList)
        buttonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonActions() {
        whishList.addTarget(self, action: #selector(didTapWishlist), for: .touchUpInside)
    }
    
    @objc private func didTapWishlist() {
        delegate?.DidTapWishlist(_header: self)
    }
}
