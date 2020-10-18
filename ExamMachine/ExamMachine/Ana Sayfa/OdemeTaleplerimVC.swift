//
//  OdemeTaleplerimVC.swift
//  ExamMachine
//
//  Created by Mac on 10.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class OdemeTaleplerimVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var odemeTalebiBanka_Tutar = [String]()
    var odemeTalebiIban = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getTaleplerim()
    }
    
    func getTaleplerim() {
        let currentUser = PFUser.current()
        let query = PFQuery(className: "OdemeTalepleri")
        query.whereKey("UserId", equalTo: currentUser)
        query.findObjectsInBackground { (objects, error) in
                if error != nil {

                } else {
                    self.odemeTalebiBanka_Tutar.removeAll(keepingCapacity: false)
                    self.odemeTalebiIban.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let banka = object.object(forKey: "BankaAdi") as? String {
                            if let tutar = object.object(forKey: "Tutar") as? String {
                                if let KayitNo = object.object(forKey: "KayitNo") as? String {
                                    self.odemeTalebiBanka_Tutar.append(KayitNo + " | " + banka + " | " + tutar + "₺")
                                    self.odemeTalebiIban.append(KayitNo)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
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
        cell.textLabel?.text = odemeTalebiBanka_Tutar[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return odemeTalebiBanka_Tutar.count
    }

}
