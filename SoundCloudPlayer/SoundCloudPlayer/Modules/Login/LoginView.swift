//
//	ViewController.swift
// 	SoundCloudPlayer
//

import UIKit
import SafariServices
import AuthenticationServices

class LoginView: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imageView.image = UIImage(named: "soundcloudLogo")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presenter?.sendLoginData(email: emailTextField.text, password: passwordTextField.text)
    }
    
}

extension LoginView: LoginViewProtocol {
    func showAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "SoundcloudOrange"), forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginButtonTapped(loginButton)
        return true
    }
}
