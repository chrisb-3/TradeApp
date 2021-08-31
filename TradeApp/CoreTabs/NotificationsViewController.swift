//
//  NotificationsViewController.swift
//  Traide'oro
//
//  Created by Christina Braun on 28.08.21.
//


import UIKit
import FirebaseAuth
import JGProgressHUD

class NotificationsViewController: UIViewController {
    
    
    public var allConvos = [Convo]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true // when there are no cenversations yet-> don't show table view
        table.register(ConversationTableViewCell.self,
                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()

    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No conversations yet"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        fetchConvos()
        reloadLatestMessage()
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)

        selfMail = safeEmail

        print("email: \(selfMail)")
        print("MESSAGE : \(latestMessage)")
        
    }
    
    private var selfMail: String = "_"
    var latestMessage: String = "_"
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noConversationsLabel.frame = CGRect(x: 10,
                                            y: (view.height-100)/2,
                                            width: view.width-20,
                                            height: 100)
        
    }
    
    
    
    private func reloadLatestMessage() {
        
        
        DatabaseManager.database.child("conversation_information").child(selfMail).child("latest_Message").observe(.value, with: {snapshot in
            let message = snapshot.value as? String
            print(message)
            if message == nil {
                print("no message")
            }
            else {
            self.latestMessage = message!
            }
            self.tableView.reloadData()
            
        } )
        
    }
    
    private func fetchConvos() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
        self.tableView.isHidden = true
        self.noConversationsLabel.isHidden = false
                print("starting listing convos...")
        
        DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").observe(.childAdded, with: {
            (snapshot) in
            
            print("test")

            let posterEmails = snapshot.key
            
            print(posterEmails)
            
            print("all chaters: \(posterEmails)")
            
            if posterEmails == String() {
                print("test")

                            print("snapshot == nil")
                            self.tableView.isHidden = true
                            self.noConversationsLabel.isHidden = false
                        }
           

            else {
                print("test")
                print("snapshot not nil")
                print(posterEmails)
                self.tableView.isHidden = false
                self.noConversationsLabel.isHidden = true
                
                DatabaseManager.database.child("Emails").child(safeEmail).child("conversations").child(posterEmails).observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let ids = snapshot.value as? String else {
                        return
                    }
                    
                    print("all conversation Ids: \(ids)")
                    
                    DatabaseManager.database.child("conversation_information").child(ids).child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
                        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                            return
                        }
                    let convo = Convo(id: ids, dictionary: dictionary)
                        
                        self.allConvos.append(convo)
                        
                        self.tableView.reloadData()
                    
                })
                
////                self.allConvos.append(posterEmails)
//
//                self.tableView.reloadData()
                
                
            })
            
//            DatabaseManager.database.child("posts").child(posterEmails).observeSingleEvent(of: .value, with: { snapshot in
//                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
//                    return
//                }
//
//                let post = PostInfo(postId: posterEmails, dictionary: dictionary)
//
////                allConvos.append(post)
//
//
//                print("Post data\(post)")
//
//                self.tableView.reloadData()
//            })
        }
            
            })
    
    }
    
    
    
    
    
//
//
//        DatabaseManager.database.child(safeEmail).child("conversations").observeSingleEvent(of: .value, with: { snapshot in
//            print("here")
//
//            let conversation = snapshot.value as? String
//            print("the snapshot \(conversation)")
//
//
//            if conversation == nil {
//                print("snapshot == nil")
//                self.tableView.isHidden = true
//                self.noConversationsLabel.isHidden = false
//            }
//
//            else {
//            DatabaseManager.database.child(safeEmail).child("conversations").observe(.childAdded, with: {
//                (snapshot) in
//                print("here")
//
//                let convoId = snapshot.key
//                print("all conversations: \(convoId)")
//
//                if convoId == "0" {
//                    print("id == 0")
//                    self.tableView.isHidden = true
//                    self.noConversationsLabel.isHidden = false
//                    return
//                }
//                else {
//                    self.tableView.isHidden = false
//                    self.noConversationsLabel.isHidden = true
//
//                DatabaseManager.database.child("convos").child(convoId).observeSingleEvent(of: .value, with: { snapshot in
//                    guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
//                        return
//                    }
//
//                    let conversation = Convo(id: convoId, dictionary: dictionary)
//
//                    self.allConvos.append(conversation)
//
//
//                    print("convo data\(conversation)")
//
//                    self.tableView.reloadData()
//                })
//                }
//                })
//
//            }
//
//
//        })
//
//
//    }
//
//
  
}


extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allConvos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = allConvos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                 for: indexPath) as! ConversationTableViewCell
//        cell.configure(with: model)
        cell.configureMessage(with: latestMessage)

        cell.chat = allConvos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = allConvos[indexPath.row]
        
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id, otherName: model.username)
        vc.title = model.username
        vc.conversationId = model.id
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true) //opens ChatViewCont. by slidng to side
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}




//
//struct Conversation {
//    let id: String
//    let username: String
//    let otherUserEmail: String
//    let latestMessage: LatestMessage
//}
//
//struct LatestMessage {
//    let date: String
//    let text: String
//    let isRead: Bool
//}
//
//struct SearchResultss {
//    let name: String
//    let email: String
//}

//class NotificationsViewController: UIViewController {
//
//
//    private let spinner = JGProgressHUD(style: .dark)
//
//    private var conversations = [Conversation]()
//
//    private let tableView: UITableView = {
//        let table = UITableView()
//        table.isHidden = true // when there are no cenversations yet-> don't show table view
//        table.register(ConversationTableViewCell.self,
//                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
//        return table
//    }()
//
//    private let noConversationsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No conversations"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "Chats"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
//                                                            target: self,
//                                                            action: #selector(didTapComposeButton))
//        view.addSubview(tableView)
//        view.addSubview(noConversationsLabel)
//        view.backgroundColor = .systemBackground
//        tableView.delegate = self
//        tableView.dataSource = self
//        fetchConversations()
//        startListingForConversations()
//    }
//
//    private func startListingForConversations() {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        print("starting conversation fetch...")
//
//
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//        DatabaseManager.shared.getAllConvos(for: safeEmail, completion: { [weak self] result in
//            switch result {
//            case .success(let conversations):
//                print("succes got conversation models")
//                guard !conversations.isEmpty else {
//                    self?.tableView.isHidden = true
//                    self?.noConversationsLabel.isHidden = false
//                    return
//                }
//                self?.noConversationsLabel.isHidden = true
//                self?.tableView.isHidden = false
//
//
//         //       let convo = Conversation(id: conversation.id,
//         //                                username: ,
//         //                                otherUserEmail: ,
//         //                                latestMessage: )
//
//      //          self?.conversations.append(conversations)
//                self?.conversations = conversations
////
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData() // ? because weak self. ? = optional
//                }
////
//            case.failure(let error):
//                print("failed to get convo \(error)")
//            }
//        })
//    }
//
//    @objc private func didTapComposeButton() {
//        let vc = NewConversationViewController()
//        vc.completion = { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//
//            let currentConversations = strongSelf.conversations
//
//            if let targetConversation = currentConversations.first(where: {
//                $0.otherUserEmail == DatabaseManager.safeEmail(emailAdress: result.email)
//        }) {
//            let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
//            vc.isNewConversation = false
//            vc.title = targetConversation.name
//            vc.navigationItem.largeTitleDisplayMode = .never
//            strongSelf.navigationController?.pushViewController(vc, animated: true)
//        }
//        else {
//            strongSelf.createNewConversation(result: result)
//        }
//        }
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
//    }
//
//
//    private func createNewConversation(result: SearchResultss) {
//        let name = result.name
//        let email = DatabaseManager.safeEmail(emailAdress: result.email)
//
//        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            switch result {
//            case .success(let conversationId):
//                let vc = ChatViewController(with: email, id: conversationId)
//                vc.isNewConversation = false
//                vc.title = name
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            case .failure(_):
//                let vc = ChatViewController(with: email, id: nil)
//                vc.isNewConversation = true
//                vc.title = name
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            }
//        })
//
////        guard let username = result["username"],
////              let email = result["email"] else {
////            return
////        }
////        let vc = ChatViewController(with: email, id: nil) // email says with wich user the conversation is with. There is no id yet so id: nil
////        vc.isNewConversation = true
////        vc.title = username
////        vc.navigationItem.largeTitleDisplayMode = .never
////        navigationController?.pushViewController(vc, animated: true) //opens ChatViewCont. by slidng to side
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//
//
//    private func fetchConversations() { // fetch from firebase the chats. Depending if exists-> show chts / show no conversationLabel
//        tableView.isHidden = false
//    }
//}

//extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return conversations.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = conversations[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
//                                                 for: indexPath) as! ConversationTableViewCell // as! means force cast // ?: this                                                                                                                                             might be nil. !: this might trap
//        cell.configure(with: model)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let model = conversations[indexPath.row]
//
//        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
//        vc.title = model.username
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true) //opens ChatViewCont. by slidng to side
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//}

