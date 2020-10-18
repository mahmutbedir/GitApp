//
//  ReferanslarimViewController.swift
//  ExamMachine
//
//  Created by Mac on 8.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class ReferanslarimViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getUserReferanlari()
    }
    
    func getUserReferanlari(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("Referansim", equalTo: (currentUser?["ReferansKodum"]) ?? "0")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {

            } else {
                self.refData.removeAll(keepingCapacity: false)

                for object in objects! {
                    if let refAdi = object.object(forKey: "username") as? String {
                        self.refData.append(refAdi)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = refData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refData.count
    }

}
