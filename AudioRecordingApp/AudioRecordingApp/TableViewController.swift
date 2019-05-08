//
//  TableViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    //, UITableViewDelegate, UITableViewDataSource
    var recordingsList = [ViewController.Recording]()
    @IBOutlet weak var myTableView: UITableView!
    
    
    //table view function to select the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    //table view function to display text in each cell (cell is the name of the prototype cell)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let call_no = list[indexPath.row] - 1
        print(call_no)
        print(recordingsList.count)

        cell.textLabel?.text = String(recordingsList[call_no].Date! + " " + recordingsList[call_no].Tag! + " " + recordingsList[call_no].Length!)
        
        return cell
    }
    
    //table view function to provide permission to edit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     //table view function to delete an entry in the table view controller
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            UserDefaults.standard.set(list, forKey: "myList")
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        // call reloading function
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
//         load tableview data(?)
        if let blogData = UserDefaults.standard.data(forKey: "myRecordingsList"){
            print("why")
            recordingsList = try! JSONDecoder().decode([ViewController.Recording].self, from: blogData)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //https://www.techotopia.com/index.php/Implementing_iOS_8_TableView_Navigation_using_Storyboards_in_Xcode_6_and_Swift
        
        let recordingInfoViewController = segue.destination as! RecordingInfoViewController
        print(self.tableView.indexPathForSelectedRow!.row)
        print(list)
        recordingInfoViewController.file_no = myTableView.indexPathForSelectedRow!.row
    }
    
    @objc func loadList(notification: NSNotification){
        //reload table view
        myTableView.reloadData()
        
        //reload data
        if let blogData = UserDefaults.standard.data(forKey: "myRecordingsList"){
            print("why")
            recordingsList = try! JSONDecoder().decode([ViewController.Recording].self, from: blogData)
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
