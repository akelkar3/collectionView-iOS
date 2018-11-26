//
//  PhotoViewController.swift
//  FirebaseInClass01
//
//  Created by Ankit Kelkar on 11/25/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase
class PhotoViewController: UIViewController {

    let rootref = Database.database().reference()
    @IBOutlet weak var imageView: UIImageView!
    var imageURL:URL?
    var date:String?
    var imageKey:String?
    let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.downloadedFrom(url: imageURL!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Photo Delete", message: "Do you want to delete this photo?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            let storageRef = self.storage.reference(withPath: "Images/\(self.uuid)/\(self.date!).jpg")
            let imageRef = self.rootref.child("Users").child(self.uuid).child("Images").child(self.imageKey!)
            imageRef.removeValue()
            storageRef.delete(completion: { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Error occurred")
                } else {
                    // File deleted successfully
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
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
