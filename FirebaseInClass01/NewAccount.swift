//
//  NewAccount.swift
//  FirebaseInClass01
//
//  Created by Ankit Kelkar on 11/12/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase

class NewAccount: UIViewController {
    
    @IBOutlet weak var confirmpasswordT: UITextField!
    
    
    @IBOutlet weak var nameT: UITextField!
    
    @IBOutlet weak var passwordT: UITextField!
    @IBOutlet weak var emailT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let username = nameT.text,
            let email = emailT.text,
            let password = passwordT.text,
            confirmpasswordT.text! == passwordT.text{
           //firebase auth
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                DispatchQueue.main.async{
                    if error != nil{
                        
                        let alert = UIAlertController(title: "Failed", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        
                        alert.addAction(okAction)
                        self.show(alert, sender: nil)
                    }
                    else{
                        print("Success in creating user \(user.debugDescription)")
                        //store uuid in userdefaults
                        UserDefaults.standard.set(user?.user.uid, forKey: "uuid")
                        let rootreference = Database.database().reference()
                        let userReference = rootreference.child("Users").child(user!.user.uid)
                        let user = [
                            "name":username,
                            "email":email
                        ]
                        userReference.setValue(user)
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            })
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
