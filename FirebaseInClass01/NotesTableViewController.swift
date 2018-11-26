//
//  NotesTableViewController.swift
//  FirebaseInClass01
//
//  Created by Ankit Kelkar on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase
class NotesTableViewController: UITableViewController {
 var key:String?
    let rootref = Database.database().reference()
    var notes:[Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
getNotesFromNotebook(key: key!)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }

    @IBAction func AddNote(_ sender: Any) {
        let addNoteAlertController = UIAlertController(title: "New Note", message: "Enter New Post Text", preferredStyle: UIAlertController.Style.alert)
        addNoteAlertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Note text"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction:UIAlertAction) in
            //call firebase save function
            let textfield = addNoteAlertController.textFields![0] as UITextField
            if let notesText = textfield.text{
                if notesText != ""{
                    let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
                    let noteReference = self.rootref.child("Notes").child(self.key!).childByAutoId();
                    let noteObject = [
                        "post" : notesText,
                        "date" : date
                    ]
                    noteReference.setValue(noteObject)
                    self.getNotesFromNotebook(key: self.key!)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addNoteAlertController.addAction(okAction)
        addNoteAlertController.addAction(cancelAction)
        self.navigationController?.present(addNoteAlertController, animated: true, completion: nil)    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notecell", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.noteTextView.text = note.post
        cell.dateTimeLabel.text = "Created on \(note.date)"
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    func getNotesFromNotebook(key:String) {
        let dataref = self.rootref.child("Notes").child(self.key!)
        dataref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.notes.removeAll()
                for value in values {
                    let key = value.key as! String
                    let object = value.value as? [String:Any]
                    let post = object!["post"] as! String
                    let date = object!["date"] as! String
                    let note = Note(post: post, date: date, key: key)
                    self.notes.append(note)
                }
                
            }
            self.tableView.reloadData()
        }
    }

    @IBAction func deleteNote(_ sender: UIButton) {
        print(sender.tag)
        let noteToDelete = notes[sender.tag]
        let noteReference = self.rootref.child("Notes").child(self.key!).child(noteToDelete.key)
        noteReference.removeValue()
        notes.remove(at: sender.tag)
        self.getNotesFromNotebook(key: self.key!)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
