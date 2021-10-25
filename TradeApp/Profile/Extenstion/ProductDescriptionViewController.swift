//
//  ProductDescriptionViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//

import UIKit
import Firebase

///textfields and image View to add a post
class ProductDescriptionViewController: UIViewController, UITextFieldDelegate {
    var pickerViewColor = UIPickerView()
    var pickerViewArticle = UIPickerView()
    var pickerViewGender = UIPickerView()
    var pickerViewExchange = UIPickerView()
    var pickerViewState = UIPickerView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private let imagePhoto: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.tintColor = .label
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
        return image
    }()
    
    private let AddImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Image"
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
        field.placeholder = "good/bad/new"
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
    
    let aditionalInformationTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Aditional Info"
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
    
    let exchangeWishLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Exchange Wish"
        return label
    }()
    
    let aditionalInformationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "More Info"
        return label
    }()
    
    let selectArticleTypes = [
        "jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "other"
    ]
    
    let selectColors = [
        "Blue", "Pink", "Yellow", "Orange", "Red", "Green", "Brown", "White", "Black", "Gray", "Mix", "Other"
    ]
    
    let selectGender = [
        "Female","Male", "Any",  "Other"
    ]
    
    let selectExchange = [
        "jeans","t-shirt","coat","shirt","dress","skirt","jacket","pants","shoes","accessories", "nothing", "bargain", "other"
    ]
    let selectProductState = [
        "good","bad","new","old","very good shape","other"
    ]
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(didTapPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
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
        
        tableView.tableHeaderView = descriptionHeader()
        tableView.tableFooterView = descriptiontextFields()
        tableView.dataSource = self
        tableView.delegate = self
        imagePhoto.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImage))
        
        imagePhoto.addGestureRecognizer(gesture)
        
    }
    /// header with selected Image
    private func descriptionHeader()-> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/2).integral)
        
        header.addSubview(imagePhoto)
        header.addSubview(AddImageLabel)
        
        imagePhoto.frame = CGRect(x: 25,
                                  y: 20,
                                  width: view.width-50,
                                  height: view.width-50)
        AddImageLabel.frame =  CGRect(x: view.width/2.5, y: header.width/2.5, width: view.width/4, height: header.height/5)
        
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
        descriptiontextFields.addSubview(city)
        descriptiontextFields.addSubview(country)
        descriptiontextFields.addSubview(size)
        descriptiontextFields.addSubview(color)
        descriptiontextFields.addSubview(productState)
        descriptiontextFields.addSubview(articleType)
        descriptiontextFields.addSubview(aditionalInformationTextField)
        
        /// labels
        descriptiontextFields.addSubview(articleTypeLabel)
        descriptiontextFields.addSubview(productTitleLabel)
        descriptiontextFields.addSubview(exchangeWishLabel)
        descriptiontextFields.addSubview(genderLabel)
        descriptiontextFields.addSubview(cityLabel)
        descriptiontextFields.addSubview(countryLabel)
        descriptiontextFields.addSubview(sizeLabel)
        descriptiontextFields.addSubview(colorLabel)
        descriptiontextFields.addSubview(productStateLabel)
        descriptiontextFields.addSubview(aditionalInformationLabel)
        
        productTitle.delegate = self
        articleType.delegate = self
        exchangeWish.delegate = self
        gender.delegate = self
        city.delegate = self
        country.delegate = self
        size.delegate = self
        color.delegate = self
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
        exchangeWish.frame = CGRect(x: productTitleLabel.right+10,
                                    y: productState.bottom+5,
                                    width: view.width-20-productTitleLabel.width,
                                    height: productTitleLabel.height)
        aditionalInformationTextField.frame = CGRect(x: productTitleLabel.right+10,
                                                     y: exchangeWish.bottom+5,
                                                     width: view.width-20-productTitleLabel.width,
                                                     height: productTitleLabel.height)
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
    
    @objc private func didTapPost() {
        print("posting")
        guard
            let postImage = imagePhoto.image,
            let productTitle = productTitle.text,
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
        guard let data = postImage.pngData() else {
            return
        }
        let filename = NSUUID().uuidString
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let posterEmail =  DatabaseManager.safeEmail(emailAdress: email)
        
        storePostDataToFirebase(with: data,
                                fileName: filename,
                                poster: posterEmail,
                                postImageNSUUID: filename,
                                articleType: articleType,
                                exchangeWish: exchangeWish,
                                productTitle: productTitle,
                                gender: gender,
                                city: city,
                                country: country,
                                size: size,
                                color: color,
                                productState: productState,
                                aditionalInformation: aditionalInfo,
                                completion: { result in
            switch result {
                /// either failure or success
            case.success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                print(downloadUrl)
                ///upload url to database
            case.failure(let error):
                print("Storage manage error: \(error)")
            }
        })
        
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
        }
        if pickerView == pickerViewState {
            return selectProductState.count
        }
        if pickerView == pickerViewGender {
            return selectGender.count
        }
        if pickerView == pickerViewExchange {
            return selectExchange.count
        }
        if pickerView == pickerViewColor {
            return selectColors.count
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
