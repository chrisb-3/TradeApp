//
//  AppInfoViewController.swift
//  TradeApp
//
//  Created by Christina Braun on 06.09.21.
//

import UIKit

class AppInfoViewController: UIViewController {

    let textBox: UILabel = {
        let text = UILabel()
        text.font = UIFont.preferredFont(forTextStyle: .body)
        text.text = "The billion dollar fashion industry has a great social, economic, and environmental meaning. Globally millions of tons of textile are produced and consumed annually. The issue is that more than two thirds of textiles go to landfills and only around 15% are being recycled. In fact the fashion industry is one of the most polluting industries in the world, contributing to water and soil pollution and carbon dioxide emissions. The consumption and disposal of fashion today is resulting into a serious environmental and health concern. This issue must be tackled. Instead of throwing away clothes we don’t utilize anymore we could instead give them away to someone that is looking for exactly that item. This is were TRADE'ORO comes in. With TRADE'ORO anyone is capable of recycceling his fashion. You can give your clothes to someone that wishes for that exact item and you get what you have been looking for. By searching in the search view you can find more precicely and with ease the items you want. As soon as you know you can contact the user and chat with him.  Your chats are saved and can be accesed anytime in the notification view. Arrange a time and date to trade your clothes. And there you go! No clothes were thrown away and you have what you want! "
        text.backgroundColor = .systemBackground
        text.numberOfLines = 0
        return text
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textBox)
        view.backgroundColor = .systemBackground
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textBox.layer.masksToBounds = true
        textBox.frame = view.bounds
    }
}
