//
//  ProductDescriptionViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import Firebase

struct LabelModels {
//    let layout: textLayout
    let LabelText: String
    let placeholder: String
}

//struct textLayout {
//    let fontSize: Int
//    let fontWeight: UIFont.Weight
//}


///textfields and image View to add a post

class ProductDescriptionViewController: UIViewController, UITextFieldDelegate {

//    public var completion: (([String: String]) -> (Void))?

    var pickerViewColor = UIPickerView()
    var pickerViewArticle = UIPickerView()
    var pickerViewGender = UIPickerView()
    var pickerViewExchange = UIPickerView()
    var pickerViewState = UIPickerView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
//        tableView.register(AddDescriptionTableViewCell.self, forCellReuseIdentifier: AddDescriptionTableViewCell.identifier)
//        tableView.register(OneBigDescriptionTableViewCell.self, forCellReuseIdentifier: OneBigDescriptionTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        return tableView
    }()

    private let imagePhoto: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()

    private let AddImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Image"
//        label.font = .systemFont
        return label
    }()

    private let productTitle: UITextField = {
            let field = UITextField()
            field.placeholder = "Title"
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
    
    private let articleType: UITextField = {
            let field = UITextField()
            field.placeholder = "T-shirt/Pants/Dress..."
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
    
    let selectArticleTypes = ["jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "other"]



//        let transactionType: UITextField = {
//            let field = UITextField()
//            field.placeholder = "transaction type"
//            field.returnKeyType = .next
//            field.leftViewMode = .always
//            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//            field.autocapitalizationType = .none
//            field.autocorrectionType = .no
//            field.layer.masksToBounds = true
//            field.layer.cornerRadius = 12
//            field.layer.borderWidth = 1
//            field.layer.borderColor = UIColor.black.cgColor
//            return field
//        }()
//        let priceLabel: UITextField = {
//            let field = UITextField()
//            field.placeholder = "priceLabel"
//            field.returnKeyType = .next
//            field.leftViewMode = .always
//            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//            field.autocapitalizationType = .none
//            field.autocorrectionType = .no
//            field.layer.masksToBounds = true
//            field.layer.cornerRadius = 12
//            field.layer.borderWidth = 1
//            field.layer.borderColor = UIColor.black.cgColor
//            return field
//        }()
//        let InExchange: UITextField = {
//            let field = UITextField()
//            field.placeholder = "Exchange Wish"
//            field.returnKeyType = .next
//            field.leftViewMode = .always
//            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//            field.autocapitalizationType = .none
//            field.autocorrectionType = .no
//            field.layer.masksToBounds = true
//            field.layer.cornerRadius = 12
//            field.layer.borderWidth = 1
//            field.layer.borderColor = UIColor.black.cgColor
//            return field
//        }()
    let country: UITextField = {
        let field = UITextField()
        field.placeholder = "country"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
        let city: UITextField = {
            let field = UITextField()
            field.placeholder = "city"
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
       
    let color: UITextField = {
        let field = UITextField()
        field.placeholder = "color"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    let selectColors = ["Blue", "Pink", "Yellow", "Orange", "Red", "Green", "Brown", "White", "Black"
    ]
    
    private let gender: UITextField = {
            let field = UITextField()
            field.placeholder = "male/female/any"
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
    
    let selectGender = ["Female",
            "Male",
            "Any",
            "Other"
    ]
    let size: UITextField = {
            let field = UITextField()
            field.placeholder = "size"
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
    
    let productState: UITextField = {
        let field = UITextField()
        field.placeholder = "good/bad/used/new"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    let selectProductState = ["good","bad","new","old","used","very good shape","other"]
    private let exchangeWish: UITextField = {
            let field = UITextField()
            field.placeholder = "I would like ... in exchange"
            field.returnKeyType = .next
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.black.cgColor
            return field
        }()
    
    let selectExchange = [
        "jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "nothing", "bargain", "other"
    ]

    let aditionalInformationTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Aditional Information"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    

    let productTitleLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Title"
       return label
   }()
    let genderLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Gender"
       return label
   }()


    let articleTypeLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Article"
       return label
   }()
    let countryLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Country"
       return label
   }()
    let cityLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "City"
       return label
   }()
    let colorLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Color"
       return label
   }()
    let sizeLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Size"
       return label
   }()
    let productStateLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Product state"
       return label
   }()
    //     let transactionTypeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "transactionType"
//        return label
//    }()
//     let priceLabelLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "priceLabel"
//        return label
//    }()
    let exchangeWishLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "Exchange Wish"
       return label
   }()
     
//     let tradeBackWishLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "Exchange Wish"
//        return label
//    }()
     
    let aditionalInformationLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.text = "More Information"
       return label
   }()
    
    struct Selesction {
        let selectionOptions: [String]
    }
    
//    public var allSelections = [Selesction]()
//
//    private func selectionArray() -> [Selesction] {
//
//        var selection: [Selesction] = []
//
//        let selectColors = Selesction(selectionOptions:["Blue", "Pink", "Yellow", "Orange", "Red", "Green", "Brown", "White", "Black"])
//
//        let selectGender = Selesction(selectionOptions:["female", "male", "any", "other"])
//
//        let selectProductState = Selesction(selectionOptions:["good","bad","new","old","used","very good shape","other"])
//
//        let selectExchange = Selesction(selectionOptions:[ "jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "nothing", "bargain", "other"])
//
//        let selectArticleTypes = Selesction(selectionOptions:["jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "other"])
//
//
//
//
////        let b7 = Buttons(backgroundImage: red, buttonLabel: "Location"
////                         , handler: {[weak self] in
////            self?.didTapGarments()
////        }, action: #selector(didTapGarments))
//
//
//        selection.append(selectColors)
//        selection.append(selectGender)
//        selection.append(selectProductState)
//        selection.append(selectExchange)
//        selection.append(selectArticleTypes)
//
//        return selectionArray()
//    }
    

//    private var labels = [LabelModels]()
//
//    private func labelArray() -> [LabelModels] {
//
//        var labels: [LabelModels] = []
//        let productTitle = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "Product Title", placeholder: "productTitle")
//
//        let transactionType = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "transactionType", placeholder: "Transaction type")
//
//        let priceLabel =  LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "price", placeholder: "price")
//        let city = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "city", placeholder: "city")
//        let country = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "country", placeholder: "country")
//        let size = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "size", placeholder: "size")
//        let color = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "color", placeholder: "color")
//        let productState = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "product state", placeholder: "product state")
//        let aditionalInformation = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "aditional information", placeholder: "iditional information")
//
//        labels.append(productTitle)
//        labels.append(transactionType)
//        labels.append(priceLabel)
//        labels.append(city)
//        labels.append(country)
//        labels.append(size)
//        labels.append(color)
//        labels.append(productState)
//        labels.append(aditionalInformation)
//
//        return labels
//
//    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(didTapPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }



//    private func configureModels() {
//        let labelTexts = [ "transaction type", "Price", "City", "Country", "Size", "Color"]
//        var section1 = [LabelModels]()
//        for label in labelTexts{
//            let model = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "\(label)", placeholder: "\(label)", height: 20)
//            section1.append(model)
//        }
//        models.append(section1)
//
//        let section2Labels = ["productState", "aditional"]
//        var section2 = [LabelModels]()
//        for label in section2Labels {
//            let model = LabelModels(layout: textLayout(fontSize: 15, fontWeight: .medium), LabelText: "\(label)", placeholder: "\(label)", height: 50)
//            section2.append(model)
//        }
//        models.append(section2)
//    }
//


//    private func tableFields() -> [Labels] {
//
//    var eightFields: [Labels] = []
//    private let productTitle: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let transactionType: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let priceLabel: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let tradeBackWish: UITextField = {
//        let field = UITextField()
//        field.placeholder = "tradeBackWish"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let city: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let country: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let size: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let color: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let productState: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
//    let aditionalInformation: UITextField = {
//        let field = UITextField()
//        field.placeholder = "username"
//        field.returnKeyType = .next
//        field.leftViewMode = .always
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        field.autocapitalizationType = .none
//        field.autocorrectionType = .no
//        field.layer.masksToBounds = true
//        field.layer.cornerRadius = 12
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.black.cgColor
//        return field
//    }()
////
//        eightFields.append(productTitle)
//    eightFields.append(transactionType)
//        eightFields.append(priceLabel)
//        eightFields.append(city)
//        eightFields.append(country)
//        eightFields.append(size)
//        eightFields.append(color)
//        eightFields.append(productState)
//        eightFields.append(aditionalInformation)
//
//        return eightFields
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Description"
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        pickerViewArticle.delegate = self
        pickerViewArticle.dataSource = self
        
        pickerViewColor.delegate = self
        pickerViewColor.dataSource = self
        
        pickerViewGender.delegate = self
        pickerViewGender.dataSource = self
        
        pickerViewExchange.delegate = self
        pickerViewExchange.dataSource = self
        
        pickerViewState.delegate = self
        pickerViewState.dataSource = self
        
        
        articleType.inputView = pickerViewArticle
        color.inputView = pickerViewColor
        gender.inputView = pickerViewGender
        productState.inputView = pickerViewState
        exchangeWish.inputView = pickerViewExchange
        
//        allSelections = selectionArray()

//        productTitle.delegate = self
//        transactionType.delegate = self
//        priceLabel.delegate = self
//        city.delegate = self
//        country.delegate = self
//        size.delegate = self
//        color.delegate = self
//        tradeBackWish.delegate = self
//        productState.delegate = self


//        view.addSubview(addPostFrame)
        tableView.tableHeaderView = descriptionHeader()
        tableView.tableFooterView = descriptiontextFields()
        tableView.dataSource = self
        tableView.delegate = self
//        labels = labelArray()
        imagePhoto.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImage))

        imagePhoto.addGestureRecognizer(gesture)

    }


//    public func addImage(with image: Int) -> Int {
//        let postImage = image
//        let number = 3
//        return number
//    }

    /// header with selected Image
    private func descriptionHeader()-> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/2).integral)


        header.addSubview(imagePhoto)
        header.addSubview(AddImageLabel)


        imagePhoto.layer.masksToBounds = true
        imagePhoto.tintColor = .label
        imagePhoto.layer.borderWidth = 1
        imagePhoto.layer.borderColor = UIColor.black.cgColor

//        view.addSubview(addPostFrame)
//        addPostFrame.frame = CGRect(x: 20,
//                                    y: 50,
//                                    width: view.width-50,
//                                    height: view.width-50)
        imagePhoto.frame = CGRect(x: 25,
                                            y: 20,
                                            width: view.width-50,
                                            height: view.width-50)
        AddImageLabel.frame =  CGRect(x: view.width/2.5, y: header.width/2.5, width: view.width/4, height: header.height/5)

////        header.backgroundColor = .blue
////        header.image =
//          image.layer.masksToBounds = true
        return header
    }

    @objc private func didTapAddImage(){
        addItem()

    }

    private func descriptiontextFields()-> UIView {
        let descriptiontextFields = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height).integral)

        ///text fields
        descriptiontextFields.addSubview(productTitle)
        descriptiontextFields.addSubview(exchangeWish)
        descriptiontextFields.addSubview(gender)
//        descriptiontextFields.addSubview(transactionType)
//        descriptiontextFields.addSubview(priceLabel)
        descriptiontextFields.addSubview(city)
        descriptiontextFields.addSubview(country)
        descriptiontextFields.addSubview(size)
        descriptiontextFields.addSubview(color)
//        descriptiontextFields.addSubview(tradeBackWish)
        descriptiontextFields.addSubview(productState)
        descriptiontextFields.addSubview(articleType)
        descriptiontextFields.addSubview(aditionalInformationTextField)
        
        /// labels
        descriptiontextFields.addSubview(articleTypeLabel)
        descriptiontextFields.addSubview(productTitleLabel)
        descriptiontextFields.addSubview(exchangeWishLabel)
        descriptiontextFields.addSubview(genderLabel)
//        descriptiontextFields.addSubview(transactionTypeLabel)
//        descriptiontextFields.addSubview(priceLabelLabel)
        descriptiontextFields.addSubview(cityLabel)
        descriptiontextFields.addSubview(countryLabel)
        descriptiontextFields.addSubview(sizeLabel)
        descriptiontextFields.addSubview(colorLabel)
//        descriptiontextFields.addSubview(tradeBackWishLabel)
        descriptiontextFields.addSubview(productStateLabel)
        descriptiontextFields.addSubview(aditionalInformationLabel)

        productTitle.delegate = self
        articleType.delegate = self
        exchangeWish.delegate = self
        gender.delegate = self
//        transactionType.delegate = self
//        priceLabel.delegate = self
        city.delegate = self
        country.delegate = self
        size.delegate = self
        color.delegate = self
//        tradeBackWish.delegate = self
        productState.delegate = self
        aditionalInformationTextField.delegate = self

        /// labels
        productTitleLabel.frame = CGRect(x: 5,
                                         y: 0,
                                         width: view.width/3-5,
                                         height: 50)
        articleTypeLabel.frame = CGRect(x: 5,
                                   y: productTitleLabel.bottom+5,
                                         width: view.width/3-5,
                                         height: 50)
//        transactionTypeLabel.frame = CGRect(x: 5,
//                                            y: productTitleLabel.bottom+5,
//                                            width: view.width/3-5,
//                                            height: 50)
//        priceLabelLabel.frame = CGRect(x: 5,
//                                       y: transactionTypeLabel.bottom+5,
//                                       width: view.width/3-5,
//                                       height: 50)
        countryLabel.frame = CGRect(x: 5,
                                    y: articleTypeLabel.bottom+5,
                                    width: view.width/3-5,
                                    height: 50)
        cityLabel.frame = CGRect(x: 5,
                                 y: countryLabel.bottom+5,
                                 width: view.width/3-5,
                                 height: 50)
       
        sizeLabel.frame = CGRect(x: 5,
                                 y: cityLabel.bottom+5,
                                 width: view.width/3-5,
                                 height: 50)
        colorLabel.frame = CGRect(x: 5,
                                  y: sizeLabel.bottom+5,
                                  width: view.width/3-5,
                                  height: 50)
        genderLabel.frame = CGRect(x: 5,
                                         y: colorLabel.bottom+5,
                                         width: view.width/3-5,
                                         height: 50)
        productStateLabel.frame = CGRect(x: 5,
                                         y: genderLabel.bottom+5,
                                         width: view.width/3-5,
                                         height: 50)
        exchangeWishLabel.frame = CGRect(x: 5,
                                         y: productStateLabel.bottom+5,
                                         width: view.width/3-5,
                                         height: 50)
        aditionalInformationLabel.frame = CGRect(x: 5,
                                           y: exchangeWishLabel.bottom+5,
                                           width: view.width/3-5,
                                           height: 50)
      



        /// text fields
        
//        transactionType.frame = CGRect(x: productTitleLabel.right+10,
//                                       y: productTitle.bottom+5,
//                                       width: view.width-20-productTitleLabel.width,
//                                       height: productTitleLabel.height)
//        priceLabel.frame = CGRect(x: productTitleLabel.right+10,
//                                  y: transactionType.bottom+5,
//                                  width: view.width-20-productTitleLabel.width,
//                                  height: productTitleLabel.height)
        
        productTitle.frame = CGRect(x: productTitleLabel.right+10,
                                    y: 0,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
        articleType.frame = CGRect(x: productTitleLabel.right+10,
                                   y: productTitle.bottom+5,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
        country.frame = CGRect(x: productTitleLabel.right+10,
                               y: articleType.bottom+5,
                               width: view.width-20-productTitleLabel.width,
                               height: productTitleLabel.height)
        city.frame = CGRect(x: productTitleLabel.right+10,
                            y: country.bottom+5,
                            width: view.width-20-productTitleLabel.width,
                            height: productTitleLabel.height)
        
        size.frame = CGRect(x: productTitleLabel.right+10,
                            y: city.bottom+5,
                            width: view.width-20-productTitleLabel.width,
                            height: productTitleLabel.height)
        color.frame = CGRect(x: productTitleLabel.right+10,
                             y: size.bottom+5,
                             width: view.width-20-productTitleLabel.width,
                             height: productTitleLabel.height)
        gender.frame = CGRect(x: productTitleLabel.right+10,
                                    y: color.bottom+5,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
        productState.frame = CGRect(x: productTitleLabel.right+10,
                                    y: gender.bottom+5,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
//        tradeBackWish.frame = CGRect(x: productTitleLabel.right+10,
//                                     y: productState.bottom+5,
//                                     width: view.width-20-productTitleLabel.width,
//                                     height: productTitleLabel.height)
        exchangeWish.frame = CGRect(x: productTitleLabel.right+10,
                                    y: productState.bottom+5,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
        aditionalInformationTextField.frame = CGRect(x: productTitleLabel.right+10,
                                      y: exchangeWish.bottom+5,
                                      width: view.width-20-productTitleLabel.width,
                                      height: productTitleLabel.height)



////        header.backgroundColor = .blue
////        header.image =
//          image.layer.masksToBounds = true
        return descriptiontextFields
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }

    private func alert (message: String) {
        let alert = UIAlertController(title: "Error", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

//    var placeholderData = [ "productTitle","productTitle","transactionType"
////                            "priceLabel"
//                            ,"city","country","size","color","Exchange_Wish","productState"
//
//    ]

    @objc private func didTapPost() {
        print("handle did tap post")


//        let productTitle = productTitle.text as! String
//        print(productTitle)


//        var index0 = IndexPath(row: 0, section: 0)
//        var index1 = IndexPath(row: 1, section: 0)
//        var index2 = IndexPath(row: 2, section: 0)
//        var index3 = IndexPath(row: 3, section: 0)
//        var index4 = IndexPath(row: 4, section: 0)
//        var index5 = IndexPath(row: 5, section: 0)
//        var index6 = IndexPath(row: 6, section: 0)
//        var index7 = IndexPath(row: 7, section: 0)
//        var index8 = IndexPath(row: 8, section: 0)
//        var index9 = IndexPath(row: 9, section: 0)
//
//        let cell: AddDescriptionTableViewCell = self.tableView.cellForRow(at: index0) as! AddDescriptionTableViewCell

//        var productTitle: String = ""
//        var transactionType: String = ""
//        var priceLabel: String = ""
//        var city: String = ""
//        var country: String = ""
//        var size: String = ""
//        var tradeBackWish: String = ""
//        var color: String = ""
//        var productState: String = ""
//
//        var index = IndexPath(row: 0, section: 0)
//
////        let row1 = indexPath.row
//        let productTitle = tableView.cellForRow(at: IndexPath) as! AddDescriptionTableViewCell

        //DBREf = darabase.batabase.reference.child("post")


//        productTitle.resignFirstResponder()
//        transactionType.resignFirstResponder()
//        priceLabel.resignFirstResponder()
//        city.resignFirstResponder()
//        country.resignFirstResponder()
//        size.resignFirstResponder()
//        tradeBackWish.resignFirstResponder()
//        color.resignFirstResponder()
//        productState.resignFirstResponder()

//        guard
//        let product = productTitle.text,
//        let transaction = transactionType.text
//        else {
//            return
//        }


        guard
            let postImage = imagePhoto.image,
        let productTitle = productTitle.text,
//        let transactionType = transactionType.text,
//        let priceLabel = priceLabel.text,
            let exchangeWish = exchangeWish.text,
            let articleType = articleType.text,
            let gender = gender.text,
        let city = city.text,
        let country = country.text,
        let size = size.text,
        let color = color.text,
        let productState = productState.text,
        let aditionalInfo = aditionalInformationTextField.text,



       !productTitle.isEmpty,
            !gender.isEmpty,
//       !transactionType.isEmpty,
//       !priceLabel.isEmpty,
       !city.isEmpty,
       !country.isEmpty,
       !size.isEmpty,
       !color.isEmpty,
       !productState.isEmpty,
       !aditionalInfo.isEmpty
        else {
            alert(message: "Please fill out all fields")
            return
        }

//        guard let uploadData = postImage.jpegData(compressionQuality: 0.5) else {
//            return
//        }
//
//    let creationDate = Date()
//
//    let filename = NSUUID().uuidString

        guard let data = postImage.pngData() else {
            return
        }

        let filename = NSUUID().uuidString

        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let posterEmail =  DatabaseManager.safeEmail(emailAdress: email)


//        StorageManager.shared.uploadProfilePostImage(with: data, fileName: filename, completion: { result in
//            switch result {
//            // either failure or success
//            case.success(let downloadUrl):
//                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                print(downloadUrl)
//
//                //upload url to database
//
//            case.failure(let error):
//                print("Storage manage error: \(error)")
//            }
//        })
//        createNewPost(postImageNSUUID: filename,
//                    productTitle: productTitle,
//                      transactionType: transactionType,
//                      priceLabel: priceLabel,
//                      city: city,
//                      country: country,
//                      size: size,
//                      color: color,
//                      productState: productState,
//                      aditionalInformation: aditionalInfo,
//                      completion: { success in
//                        if success {
//                            print("created new post")
//                        }
//                        else {
//                            print("failed to create new post")
//                        }
//                      })
        storePostDataToFirebase(with: data,
                                fileName: filename,
                                poster: posterEmail,
                                postImageNSUUID: filename,
                                articleType: articleType,
                                exchangeWish: exchangeWish,
                                productTitle: productTitle,
                                gender: gender,
//                                priceLabel: priceLabel,
                                city: city,
                                country: country,
                                size: size,
                                color: color,
                                productState: productState,
                                aditionalInformation: aditionalInfo,
                                completion: { result in
                        switch result {
                        // either failure or success
                        case.success(let downloadUrl):
                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                            print(downloadUrl)

                            //upload url to database

                        case.failure(let error):
                            print("Storage manage error: \(error)")
                        }
                    })


//        DatabaseManager.shared.addPostToFirebase(with: posterEmail,
//                                                 postImageNSUUID: filename,
//                                                 transactionType: transactionType,
//                                                 priceLabel: priceLabel,
//                                                 city: city,
//                                                 country: country,
//                                                 size: size,
//                                                 color: color,
//                                                 productState: productState,
//                                                 aditionalInformation: aditionalInfo,
//                                                 completion: { success in
//                                                    if success {
//                                                        print("created new post in post")
//                                                    }
//                                                    else {
//                                                        print("failed to create new post in post")
//                                                    }
//                                                  })
//




//        print("working")
//        print(product)
//        print("working2")
//        print(transactionType.text)
//        print("working3")
////        print("\(priceLabel)")
////        print("\(city)")
////        print("\(country)")
////        print("\(size)")
////        print("\(color)")
////        print("\(productState)")
//
//        guard let currentUserUid = Auth.auth().currentUser?.uid else {
//            return
//        }

//        createNewPost(imageeUrl: postImageUrl,
//                        productTitle: productTitle,
//                      transactionType: transactionType,
//                      priceLabel: priceLabel,
//                      city: city,
//                      country: country,
//                      size: size,
//                      color: color,
//                      productState: productState,
//                      aditionalInformation: aditionalInfo,
//                      completion: { success in
//                        if success {
//                            print("created new post")
//                        }
//                        else {
//                            print("failed to create new post")
//                        }
//                      })

//        productTitle.resignFirstResponder()
//        transactionType.resignFirstResponder()
//        priceLabel.resignFirstResponder()
//        city.resignFirstResponder()
//        country.resignFirstResponder()
//        size.resignFirstResponder()
//        color.resignFirstResponder()
//        productState.resignFirstResponder()
//        aditionalInformation.resignFirstResponder()

        navigationController?.dismiss(animated: true, completion: nil)
    }




    @objc private func didTapCancel(){

        navigationController?.dismiss(animated: true, completion: nil)

    }
}
extension ProductDescriptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func addItem() {
    let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true

            present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.editedImage] as? UIImage else {
                    return
                }
        self.imagePhoto.image = selectedImage
        imagePhoto.layer.borderColor = UIColor.lightGray.cgColor
        AddImageLabel.isHidden = true


    }


}

extension ProductDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier) as! EmptyTableViewCell

                    return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// Empty Cell wich serves as padding at the bottom of the OneBigDescriptionTableViewCell
class EmptyTableViewCell: UITableViewCell {
    
    static let identifier = "EmptyTableViewCell"
    
}


extension ProductDescriptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewArticle {
            return selectArticleTypes.count
            print("count \(selectArticleTypes.count)")
        }
        if pickerView == pickerViewState {
            return selectProductState.count
            print("count \(selectProductState.count)")

        }
        if pickerView == pickerViewGender {
            return selectGender.count
            print("count \(selectGender.count)")

        }
        if pickerView == pickerViewExchange {
            return selectExchange.count
            print("count \(selectExchange.count)")

        }
        if pickerView == pickerViewColor {
            return selectColors.count
            print("count \(selectColors.count)")

        }
        return 0
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewColor {
        return selectColors[row]
        }
        if pickerView == pickerViewArticle {
        return selectArticleTypes [row]
        }
        if pickerView == pickerViewGender {
        return selectGender [row]
        }
        if pickerView == pickerViewState {
        return selectProductState[row]
        }
        if pickerView == pickerViewExchange {
        return selectExchange[row]
        }
        return selectExchange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewArticle {
        articleType.text = selectArticleTypes[row]
        articleType.resignFirstResponder()
        }
        
        if pickerView == pickerViewColor {
        color.text = selectColors[row]
        color.resignFirstResponder()
        }
        
        if pickerView == pickerViewGender {
        gender.text = selectGender[row]
        gender.resignFirstResponder()
        }
        
        if pickerView == pickerViewState {
        productState.text = selectProductState[row]
        productState.resignFirstResponder()
        }
        
        if pickerView == pickerViewExchange {
        exchangeWish.text = selectExchange[row]
        exchangeWish.resignFirstResponder()
        }
    }
    
    
}
