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
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imageView.image = UIImage(named: "soundcloudLogo")
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presenter?.login()
    }
    
}

extension LoginView: LoginViewProtocol {
    func showSafariAuth(with url: URL) {
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
