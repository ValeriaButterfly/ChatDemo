//
//  ViewController.swift
//  TestChat
//
//  Created by Valeria Muldt on 11.07.2020.
//  Copyright © 2020 Valeria Muldt. All rights reserved.
//

import UIKit

struct Message {
    let type: Type
    let body: String
    let time: String
}

enum Type {
    case incoming
    case outcoming
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    @IBOutlet weak var viewTextHC: NSLayoutConstraint!
    @IBOutlet weak var viewToUp: UIView!
    
    @IBOutlet weak var viewTextBC: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = false
        }
    }
    var arrayOfOutcomingMessage = [
        Message(type: .incoming, body: "Test", time: "12%25"),
        Message(type: .outcoming, body: "Hello", time: "12%30"),
        Message(type: .incoming, body: "Hello there again", time: "12%35")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "incomingMessage")
        tableView.register(UINib(nibName: "OutcomingTableViewCell", bundle: nil), forCellReuseIdentifier: "outcomingMessage")
        
//        textViewHC.constant = self.textView.contentSize.height
//        viewTextHC.constant = self.textView.contentSize.height + 15
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKb))
        tableView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    
    @objc func hideKb() {
        self.view.endEditing(true)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
            
            print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            viewTextBC.constant = isKeyboardShowing ? keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                let indexPath = IndexPath(row: self.arrayOfOutcomingMessage.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
//        arrayOfOutcomingMessage.append(textView.text)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: Date())
        
        arrayOfOutcomingMessage.append(Message(type: .outcoming, body: textView.text, time: dateString))
        tableView.reloadData()
        let indexPath = IndexPath(row: self.arrayOfOutcomingMessage.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfOutcomingMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch arrayOfOutcomingMessage[indexPath.row].type {
        case .incoming:
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingMessage", for: indexPath) as! TableViewCell
//            cell.messageLabel.text = "This is a test messageThis is a test messageThis is a test message"
            cell.messageLabel.text = arrayOfOutcomingMessage[indexPath.row].body
            return cell
        case .outcoming:
            let cell = tableView.dequeueReusableCell(withIdentifier: "outcomingMessage", for: indexPath) as! OutcomingTableViewCell
            cell.messageLabel.text = arrayOfOutcomingMessage[indexPath.row].body
            return cell
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        if textView.text == "" || textView.textColor == UIColor.lightGray {
            sendButton.isEnabled = false
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height < 150 {
            textViewHC.constant = self.textView.contentSize.height
            viewTextHC.constant = self.textView.contentSize.height + 15
        }
        
        sendButton.isEnabled = textView.text != "" ? true : false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
            textView.textColor = .lightGray
        }
    }
}
