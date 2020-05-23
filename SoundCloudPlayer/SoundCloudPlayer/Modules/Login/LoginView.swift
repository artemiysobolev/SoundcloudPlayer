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
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imageView.image = UIImage(named: "soundcloudLogo")
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presenter?.sendLoginData(email: emailTextField.text, password: passwordTextField.text)
    }
    
}

extension LoginView: LoginViewProtocol {
    func showAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "SoundcloudOrange"), forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
