//
//  ViewController.swift
//  workingSendBar
//
//  Created by Subash Dantuluri on 8/28/16.
//  Copyright © 2016 Subash Dantuluri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sendBar = CustomSendBarView()
    let keyboardObserver = KeyboardObserver()
    
    @IBOutlet weak var tableView: UITableView!
    
    // This is how we observe the keyboard position
    override var inputAccessoryView: UIView? {
        get {
            return keyboardObserver
        }
    }
    
    // This is also required
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .Interactive
        tableView.backgroundColor = UIColor.lightGrayColor()
        configureInputBar()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardFrameChanged(_:)), name: FrameDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sendBar.frame.size.width = view.bounds.size.width
    }
    
    
    func configureInputBar() {
        
        keyboardObserver.userInteractionEnabled = false
        sendBar.frame = CGRectMake(0, view.frame.size.height - 44, view.frame.size.width, 44)
        sendBar.keyboardObserver = keyboardObserver
        view.addSubview(sendBar)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Sign Out of Support App?", comment: ""), message: nil, preferredStyle: .ActionSheet)
            let ok = UIAlertAction(title: NSLocalizedString("Sign out", comment: ""), style: .Default) { action in
                //UIApplication.sharedApplication().sendAction(#selector(keyboardFrame), to: nil, from: sender, forEvent: nil)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if self.isFirstResponder() {
        self.resignFirstResponder()
        } else {
            self.becomeFirstResponder()
        }
    }
    
    func keyboardFrameChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            sendBar.frame.origin.y = frame.origin.y
            tableView.frame.size.height = view.frame.size.height - (view.frame.size.height - frame.origin.y)
            view.layoutIfNeeded()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            sendBar.frame.origin.y = frame.origin.y
            tableView.frame.size.height = view.frame.size.height - (view.frame.size.height - frame.origin.y)
            view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            sendBar.frame.origin.y = frame.origin.y
            tableView.frame.size.height = view.frame.size.height - (view.frame.size.height - frame.origin.y)
            view.layoutIfNeeded()
        }
    }
    
}
