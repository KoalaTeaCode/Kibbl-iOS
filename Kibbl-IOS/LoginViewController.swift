//
//  LoginViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/8/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SwifterSwift
import PKHUD
import SideMenu
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    
//    let containerView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let topView = UIView()
    let bottomView = UIView()
    
    let imageView = UIImageView()
    let stackView = UIStackView()
    
    let emailTextField = TextField()
    let passwordTextField = TextField()
    let passwordConfirmTextField = TextField()
//    let firstNameTextField = TextField()
//    let lastNameTextField = TextField()
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    let facebookButton = LoginButton(readPermissions: [.publicProfile,.email])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performLayout()
        self.view.backgroundColor = Stylesheet.Colors.base
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar?.setColors(background: Stylesheet.Colors.base, text: Stylesheet.Colors.white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationBar?.setColors(background: Stylesheet.Colors.white, text: Stylesheet.Colors.base)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        if User.getActiveUser()?.isLoggedIn() != false {
            HUD.show(.systemActivity)
            // If so move on to the next screen
            let vc = CustomTabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func performLayout() {
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(stackView)
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview().priority(100)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().priority(99)
            make.bottom.equalTo(stackView.snp.bottom).offset(20).priority(100)
        }
        
        setupStackView()
        setupImageview()
        setupTextFields()
        setupButtons()
    }
    private func setupTopBottomViews() {
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        
        topView.isUserInteractionEnabled = false
        bottomView.isUserInteractionEnabled = false

        topView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view).dividedBy(2)
        }
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(view).dividedBy(2)
        }
    }
    
    private func setupStackView() {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        self.stackView.addArrangedSubview(emailTextField)
        self.stackView.addArrangedSubview(passwordTextField)
        self.stackView.addArrangedSubview(passwordConfirmTextField)
//        self.stackView.addArrangedSubview(firstNameTextField)
//        self.stackView.addArrangedSubview(lastNameTextField)
        self.stackView.addArrangedSubview(loginButton)
        self.stackView.addArrangedSubview(signUpButton)
        self.stackView.addArrangedSubview(facebookButton)
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.center)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(facebookButton)
        }
    }
    
    private func setupImageview() {
        self.scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "KibbleWithText")

        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(50)
            
            let height = Helpers.calculateHeight(forHeight: 200)
            make.height.equalTo(height)
            make.width.equalTo(height)
        }
    }
    
    private func setupTextFields() {
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
        }
        
        passwordConfirmTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
        }
        
//        firstNameTextField.snp.makeConstraints { (make) -> Void in
//            make.left.right.equalToSuperview().inset(20)
//            
//            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
//        }
//        
//        lastNameTextField.snp.makeConstraints { (make) -> Void in
//            make.left.right.equalToSuperview().inset(20)
//            
//            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
//        }
        
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = Stylesheet.Colors.light2
        emailTextField.textColor = Stylesheet.Colors.white
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.cornerRadius = 14
        
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = Stylesheet.Colors.light2
        passwordTextField.textColor = Stylesheet.Colors.white
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.cornerRadius = 14
        
        passwordConfirmTextField.isHidden = true
        passwordConfirmTextField.placeholder = "Confirm Password"
        passwordConfirmTextField.backgroundColor = Stylesheet.Colors.light2
        passwordConfirmTextField.textColor = Stylesheet.Colors.white
        passwordConfirmTextField.autocorrectionType = .no
        passwordConfirmTextField.autocapitalizationType = .none
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmTextField.cornerRadius = 14
        
//        firstNameTextField.isHidden = true
//        firstNameTextField.placeholder = "First Name"
//        firstNameTextField.backgroundColor = Stylesheet.Colors.light2
//        firstNameTextField.textColor = Stylesheet.Colors.white
//        firstNameTextField.autocorrectionType = .no
//        firstNameTextField.autocapitalizationType = .none
//        firstNameTextField.cornerRadius = 14
//        
//        lastNameTextField.isHidden = true
//        lastNameTextField.placeholder = "Last Name"
//        lastNameTextField.backgroundColor = Stylesheet.Colors.light2
//        lastNameTextField.textColor = Stylesheet.Colors.white
//        lastNameTextField.autocorrectionType = .no
//        lastNameTextField.autocapitalizationType = .none
//        lastNameTextField.cornerRadius = 14
    }
    
    private func setupButtons() {
        loginButton.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 42))
        }
        
        signUpButton.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 42))
        }
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(Stylesheet.Colors.white, for: .normal)
        loginButton.setBackgroundColor(color: Stylesheet.Colors.dark2, forState: .normal)
        loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: .touchUpInside)
        loginButton.cornerRadius = 14
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(Stylesheet.Colors.white, for: .normal)
        signUpButton.setBackgroundColor(color: Stylesheet.Colors.dark2, forState: .normal)
        signUpButton.addTarget(self, action: #selector(self.signUpButtonPressed), for: .touchUpInside)
        signUpButton.cornerRadius = 14
        
        facebookButton.delegate = self
        facebookButton.snp.makeConstraints { (make) -> Void in
//            make.left.right.equalToSuperview().inset(20)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
        }
    }
    
    func loginButtonPressed() {
        passwordConfirmTextField.isHidden = true
//        firstNameTextField.isHidden = true
//        lastNameTextField.isHidden = true
        
        guard !emailTextField.isEmpty else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.emailEmpty)
            return
        }
        
        guard let email = emailTextField.text else { return }
        guard Helpers.isValidEmailAddress(emailAddressString: email) else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.emailWrongFormat)
            return
        }
        
        guard !passwordTextField.isEmpty else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordEmpty)
            return
        }
        
        guard let password = passwordTextField.text else { return }
        guard password.length >= 6 else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordNotLongEnough)
            return
        }
        
        // API Login Call
        HUD.show(.systemActivity)
        API.sharedInstance.login(email: email, password: password, completion: { (success) -> Void in
            
            if success == false {
                HUD.hide()
                return
            }
            HUD.hide({ _ in
                self.navigationController?.popViewController()
            })
        })
    }
    
    func signUpButtonPressed() {
        if passwordConfirmTextField.isHidden == true {
            passwordConfirmTextField.isHidden = false
//            firstNameTextField.isHidden = false
//            lastNameTextField.isHidden = false
            return
        }
        
        guard !emailTextField.isEmpty else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.emailEmpty)
            return
        }
        
        guard let email = emailTextField.text else { return }
        guard Helpers.isValidEmailAddress(emailAddressString: email) else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.emailWrongFormat)
            return
        }
        
        guard !passwordTextField.isEmpty else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordEmpty)
            return
        }
        
        guard let password = passwordTextField.text else { return }
        guard password.length >= 6 else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordNotLongEnough)
            return
        }
        
        guard !passwordConfirmTextField.isEmpty else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordConfirmEmpty)
            return
        }
        
        guard let passwordConfirm = passwordConfirmTextField.text else { return }
        guard passwordConfirm == password else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.passwordsDonotMatch)
            return
        }
        
//        guard !firstNameTextField.isEmpty else {
//            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.firstNameEmpty)
//            return
//        }
//        
//        guard let firstName = firstNameTextField.text else { return }
//        guard firstName.length >= 2 else {
//            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.lastNameNotLongEnough)
//            return
//        }
//        
//        guard !lastNameTextField.isEmpty else {
//            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.lastNameEmpty)
//            return
//        }
//        
//        guard let lastName = lastNameTextField.text else { return }
//        guard lastName.length >= 2 else {
//            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.lastNameNotLongEnough)
//            return
//        }

        // API Login Call
        HUD.show(.systemActivity)
        API.sharedInstance.register(email: email, password: password, completion: { (success) -> Void in
            
            if success == false {
                HUD.hide()
                return
            }
            
            // Completed so present Tab controller
            let vc = CustomTabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("User cancelled login.")
        case .success(_,_, let accessToken):
            HUD.show(.systemActivity)
            print("Logged in!")
            API.sharedInstance.facebookLogin(completion: { (success) -> Void in
                
                if success == false {
                    HUD.hide()
                    return
                }
                
                // Completed so present Tab controller
                let vc = CustomTabViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did logout via LoginButton")
        //@TODO: clear user stuff
    }
}
