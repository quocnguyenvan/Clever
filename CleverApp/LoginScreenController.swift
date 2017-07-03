//
//  LoginScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/6/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class LoginScreenController: UIViewController {

    var userName: String = ""
    @IBOutlet weak var txtUsername: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnChangePassTap(_ sender: UIButton) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 3
        btnCancel.layer.cornerRadius = 3
        txtUsername.text = userName
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreenController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreenController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
//        self.txtUsername.center.y -= self.view.bounds.width
//        self.txtPassword.center.x -= self.view.bounds.width
//        btnCancel.center.x - = self.view.bounds.width
        
        btnLogin.alpha = 0.0
        btnCancel.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.btnLogin.alpha = 1.0
            },
        completion: nil)
        
        UIView.animate(
            withDuration: 0.65,
            animations: {
                self.btnCancel.alpha = 1.0
        },
        completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func btnLoginTap(_ sender: UIButton) {
        Login()
    }
    
    @IBAction func btnCancelTap(_ sender: UIButton) { }
    
    func Login() {
//        guard let username = txtUsername.text, userName != "" else { return }
        guard let passcode = txtPassword.text, passcode != "" else { return }
        if (passcode == "123") {
            let panel = storyboard?.instantiateViewController(withIdentifier: "Panel") as! PanelController
            navigationController?.pushViewController(panel, animated: true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 120
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil{
            self.view.frame.origin.y = 0
        }
    }
}
