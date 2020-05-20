//
//	ViewController.swift
// 	SoundCloudPlayer
//

import UIKit

class LoginView: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        //reference to soundcloud.
    }
}
