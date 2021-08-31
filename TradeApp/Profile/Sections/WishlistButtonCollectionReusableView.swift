//
//  WishlistButtonCollectionReusableView.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit

protocol WishlistButtonCollectionReusableViewDelegate: AnyObject {

    func DidTapPostsButton(_header: WishlistButtonCollectionReusableView)
    func DidTapWishlist(_header: WishlistButtonCollectionReusableView)

    
}

class WishlistButtonCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "WishlistButtonCollectionReusableView"
    
    public weak var delegate: WishlistButtonCollectionReusableViewDelegate?
    
    
    
    private let PostsButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .darkText
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Posts", for: .normal)
        return button
    }()
    
    private let whishList: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .darkText
        button.backgroundColor = .darkGray
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Wishlist", for: .normal)
        return button
    }()
    
    private let PostsLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .tertiarySystemBackground
        label.textColor = .label
        label.text = "1"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
//    ///Buttons
//    private let TradeButton: UIButton = {
//        let button = UIButton()
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitleColor(.white, for: .normal)
//        button.tintColor = .darkText
//        button.backgroundColor = .systemRed
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        button.setTitle("Trade", for: .normal)
//        return button
//    }()
//
//    private let SellButton: UIButton = {
//        let button = UIButton()
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitleColor(.white, for: .normal)
//        button.tintColor = .darkText
//        button.backgroundColor = .systemRed
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        button.setTitle("Sell", for: .normal)
//        return button
//    }()
//
//    private let FabricsButton: UIButton = {
//        let button = UIButton()
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitleColor(.white, for: .normal)
//        button.tintColor = .darkText
//        button.backgroundColor = .systemRed
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        button.setTitle("Fabrics", for: .normal)
//        return button
//    }()
//
//    private let AllButton: UIButton = {
//        let button = UIButton()
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitleColor(.white, for: .normal)
//        button.tintColor = .darkText
//        button.backgroundColor = .systemRed
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        button.setTitle("All", for: .normal)
//        return button
//    }()
//
//
//    ///Lables
//    private let TradeLabel: UILabel = {
//        let label = UILabel()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.backgroundColor = .tertiarySystemBackground
//        label.textColor = .label
//        label.text = "56"
//        label.font = .systemFont(ofSize: 20, weight: .regular)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let SellLabel: UILabel = {
//        let label = UILabel()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.backgroundColor = .tertiarySystemBackground
//        label.textColor = .label
//        label.text = "3"
//        label.font = .systemFont(ofSize: 20, weight: .regular)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let FabricsLabel: UILabel = {
//        let label = UILabel()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.backgroundColor = .tertiarySystemBackground
//        label.textColor = .label
//        label.text = "0"
//        label.font = .systemFont(ofSize: 20, weight: .regular)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let AllLabel: UILabel = {
//        let label = UILabel()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.backgroundColor = .tertiarySystemBackground
//        label.textColor = .label
//        label.text = "59"
//        label.font = .systemFont(ofSize: 20, weight: .regular)
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        return label
//    }()
//
    override func layoutSubviews() {
        
        ///button layout
//        let buttonSize = (width-50)/8
//        let xPosition = CGFloat(20)
//        let buttonWidth = buttonSize*5.5
        let buttonSize = (width/6)
        let xPosition = CGFloat(10)
        let buttonWidth = width-buttonSize*2
        
        
        PostsButton.frame = CGRect(x: xPosition,
                                   y: 20,
                                   width: buttonWidth,
                                   height: buttonSize)
        whishList.frame = CGRect(x: 10,
                                 y: 20,
                                 width: width-20,
                                 height: width/6)
        
//        TradeButton.frame = CGRect(x: xPosition,
//                                   y: 15,
//                                   width: buttonWidth,
//                                   height: buttonSize)
//        SellButton.frame = CGRect(x: xPosition,
//                                  y: TradeButton.bottom+15,
//                                  width: buttonWidth,
//                                  height: buttonSize)
//        FabricsButton.frame = CGRect( x: xPosition,
//                                      y: SellButton.bottom+15,
//                                      width: buttonWidth,
//                                      height: buttonSize)
//        AllButton.frame = CGRect(x: xPosition,
//                                 y: FabricsButton.bottom+15,
//                                 width: buttonWidth,
//                                 height: buttonSize)
//
        
        ///lable layout
        let didtanceToButton = CGFloat(10)
        let lablewidth = (width-buttonWidth-didtanceToButton-xPosition-10)
        let lablehight = buttonSize
        
        PostsLabel.frame = CGRect(x: PostsButton.right+didtanceToButton,
                                  y: 20,
                                  width: lablewidth,
                                  height: lablehight)
        
//        TradeLabel.frame = CGRect(x: TradeButton.right+didtanceToButton,
//                                  y: 15,
//                                  width: lablewidth,
//                                  height: lablehight)
//
//        SellLabel.frame = CGRect(x: SellButton.right+didtanceToButton,
//                                 y: TradeLabel.bottom+15,
//                                 width: lablewidth,
//                                 height: lablehight)
//
//        FabricsLabel.frame = CGRect(x: FabricsButton.right+didtanceToButton,
//                                    y: SellLabel.bottom+15,
//                                    width: lablewidth,
//                                    height: lablehight)
//
//        AllLabel.frame = CGRect(x: AllButton.right+didtanceToButton,
//                                y: FabricsLabel.bottom+15,
//                                width: lablewidth,
//                                height: lablehight)
//
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(PostsButton)
//        addSubview(PostsLabel)
        addSubview(whishList)
        
//        addSubview(TradeButton)
//        addSubview(SellButton)
//        addSubview(FabricsButton)
//        addSubview(AllButton)
//
//        addSubview(TradeLabel)
//        addSubview(SellLabel)
//        addSubview(FabricsLabel)
//        addSubview(AllLabel)
        buttonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonActions() {
        
        PostsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        
        whishList.addTarget(self, action: #selector(didTapWishlist), for: .touchUpInside)
        
//        TradeButton.addTarget(self, action: #selector(didTapTradeButton), for: .touchUpInside)
//        SellButton.addTarget(self, action: #selector(didTapSellButton), for: .touchUpInside)
//        FabricsButton.addTarget(self, action: #selector(didTapFabricsButton), for: .touchUpInside)
//        AllButton.addTarget(self, action: #selector(didTapAllButton), for: .touchUpInside)
        
    }
    @objc private func didTapPostsButton() {
        //show posted trade items
        delegate?.DidTapPostsButton(_header: self)
        
    }
    
    @objc private func didTapWishlist() {
        //show posted trade items
        delegate?.DidTapWishlist(_header: self)
        
    }
    
//    @objc private func didTapTradeButton() {
//        //show posted trade items
//        delegate?.DidTapTradeButton(_header: self)
//
//    }
//    @objc private func didTapSellButton() {
//        //show posted sell items
//        delegate?.DidTapTradeButton(_header: self)
//    }
//    @objc private func didTapFabricsButton() {
//        //show posted fabrics items
//        delegate?.DidTapTradeButton(_header: self)
//    }
//    @objc private func didTapAllButton() {
//        //scroll to all
//        delegate?.DidTapTradeButton(_header: self)
//    }
    
}
