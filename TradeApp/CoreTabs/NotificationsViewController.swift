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
        print("message : \(latestMessage)")
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
            if message == nil { print("no message")
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
            
            let posterEmails = snapshot.key
            
            print(posterEmails)
            
            print("all chaters: \(posterEmails)")
            
            if posterEmails == String() {
                
                print("snapshot == nil")
                self.tableView.isHidden = true
                self.noConversationsLabel.isHidden = false
            }
            
            else {
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
                })
            }
        })
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allConvos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                 for: indexPath) as! ConversationTableViewCell
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
