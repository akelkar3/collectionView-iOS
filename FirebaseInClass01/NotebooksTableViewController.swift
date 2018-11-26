//
//  NotebooksTableViewController.swift
//  FirebaseInClass01
//
//  Created by Ankit Kelkar on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase
class NotebooksTableViewController: UITableViewController {

    let rootref = Database.database().reference()
    var notebooks:[NoteBook] = []
    let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserNotebooks(uuid: uuid)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notebooks.count
    }

    @IBAction func AddNoteBook(_ sender: Any) {
        let addNotebookAlertController = UIAlertController(title: "New Notebook", message: "Enter Notebook Title", preferredStyle: UIAlertController.Style.alert)
        addNotebookAlertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Notebook Title"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction:UIAlertAction) in
            //call firebase save function
            let textfield = addNotebookAlertController.textFields![0] as UITextField
            if let notebookname = textfield.text{
                if notebookname != ""{
                    let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
                    let notebookReference = self.rootref.child("Notebooks").child(self.uuid).childByAutoId()
                    let notebookObject = [
                        "name" : notebookname,
                        "date" : date
                    ]
                    notebookReference.setValue(notebookObject)
                    self.getUserNotebooks(uuid: self.uuid)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addNotebookAlertController.addAction(okAction)
        addNotebookAlertController.addAction(cancelAction)
       //show alert for adding a new notebook
        self.navigationController?.present(addNotebookAlertController, animated: true, completion: nil)
    }
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "uuid")
        do {
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            print(signoutError.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    func getUserNotebooks(uuid:String) {
        let dataref = self.rootref.child("Notebooks").child(self.uuid)
        dataref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.notebooks.removeAll()
                for value in values {
                    let key = value.key as! String
                    let object = value.value as? [String:Any]
                    let name = object!["name"] as! String
                    let date = object!["date"] as! String
                    let notebook = NoteBook(name: name, date: date, key: key)
                    self.notebooks.append(notebook)
                }
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebook", for: indexPath)
        let notebook = notebooks[indexPath.row]
        cell.textLabel?.text = notebook.name
        cell.detailTextLabel?.text = "Created on \(notebook.date)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notebook = notebooks[indexPath.row]
        let notebookKey = notebook.key
        performSegue(withIdentifier: "showNotes", sender: notebookKey)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let key = sender as? String{
            let notesVC = segue.destination as? NotesTableViewController
            notesVC?.key = key
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
