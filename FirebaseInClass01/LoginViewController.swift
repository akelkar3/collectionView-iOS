//
//  LoginViewController.swift
//  FirebaseInClass01
//
//  Created by Kelkar,Ankit on 11/9/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil{
            performSegue(withIdentifier: "notebooksegue", sender: nil)
        }
    }

    @IBAction func Login(_ sender: UIButton) {
        if let email = email.text,
            let password = password.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil{
                    let alertController = UIAlertController(title: "Log in failed", message: "Please enter valid email id and password. Or click on Create New Account to create a New Accont and login", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.show(alertController, sender: nil)
                }
                else{
                    let uuid = user?.user.uid
                    UserDefaults.standard.set(uuid, forKey: "uuid")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "notebooksegue", sender: nil)
                    }
                }
            })
        }
    }
}

