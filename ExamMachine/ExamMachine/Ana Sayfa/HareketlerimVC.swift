//
//  HareketlerimVC.swift
//  ExamMachine
//
//  Created by Mac on 11.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class HareketlerimVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var tableView: UITableView!
    
    var AktiviteId = [String]()
    var DogruCevap = [String]()
    var UserCevap = [String]()
    var Toplu = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getSoruHareketlerim()
    }
    
    func getSoruHareketlerim(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "SoruAktiviteleri")
        query.whereKey("UserId", equalTo: currentUser)
        query.findObjectsInBackground { (objects, error) in
                if error != nil {

                } else {
                    self.AktiviteId.removeAll(keepingCapacity: false)
                    self.DogruCevap.removeAll(keepingCapacity: false)
                    self.UserCevap.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let AktiviteId_ = object.objectId as? String {
                            if let DogruCevap_ = object.object(forKey: "DogruCevap") as? String {
                                if let UserCevap_ = object.object(forKey: "UserCevap") as? String {
                                    self.Toplu.append("Id: " + AktiviteId_ + " | Doğru C.: " + DogruCevap_ + " | Cevabın:" + UserCevap_)
                                }
                            }
                        }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Toplu[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Toplu.count
    }

}
