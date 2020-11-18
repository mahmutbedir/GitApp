//
//  GameViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblSoruDegeri: UILabel?
    @IBOutlet weak var lblXP: UILabel?
    
    var soruNameArray = [String]()
    var soruIdArray = [String]()
    
    var userEnerji = 0.00
    
    var soruAktiviteleriID = [String]()
    
    var selectedSoruId = ""
    var soruXPL = [Double]()
    var soruDegeriL = [Double]()
    
    var refreshControl = UIRefreshControl()
    
    var activityind : UIActivityIndicatorView = UIActivityIndicatorView()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserBilgileri()
        getSoruAktiviteleri()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title:"< Back",style: .plain, target: self, action: #selector(backButtonClicked))
                
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Yenile")
        refreshControl.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        activityIndCagir()
    }
    
    @objc func refresh() {
        getSoruAktiviteleri()
   }
    
    @objc func refreshTable(_ sender: AnyObject) {
        getSoruAktiviteleri()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSoruDetail" {
            let soruDetayVC = segue.destination as! SoruDetayViewController
            soruDetayVC.secilenSoruId = selectedSoruId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userEnerji <= 0 {
            makeAlert(titleInput: "Enerjiniz tükendi", messageInput: "Saat başında devam edebilirsin :)")
        } else {
            selectedSoruId = soruIdArray[indexPath.row]
            self.performSegue(withIdentifier: "toSoruDetail", sender: nil)
        }

        
        //let alert = UIAlertController(title: soruIdArray[indexPath.row], message: soruIdArray[indexPath.row], preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        //}))

        //self.present(alert, animated: true, completion: nil)
    }
    
    func getSorularFromParse() {
        let query = PFQuery(className: "Sorular")
        query.whereKey("objectId", notContainedIn: soruAktiviteleriID)
        query.whereKey("Kabul", equalTo: true)
        //makeAlert(titleInput: "Adet", messageInput: String(soruAktiviteleriID.count))
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Kodu 1002!")
            } else {
                
                self.soruIdArray.removeAll(keepingCapacity: false)
                self.soruNameArray.removeAll(keepingCapacity: false)
                self.soruXPL.removeAll(keepingCapacity: false)
                self.soruDegeriL.removeAll(keepingCapacity: false)
                
                    if objects != nil {
                        for object in objects! {
                            if let soruid = object.objectId {
                                for soru in self.soruAktiviteleriID {
                                    if soru == soruid {
                                        return
                                    }
                                }
                                self.soruIdArray.append(soruid)
                                
                                if let soruName = object.object(forKey: "Soru") as? String {
                                        self.soruNameArray.append(soruName)
                                }
                                if let kazanc = object.object(forKey: "Kazanc") as? Double {
                                    self.soruDegeriL.append(kazanc)
                                }
                                if let xp = object.object(forKey: "XpDegeri") as? Double {
                                    self.soruXPL.append(xp)
                                }
                            }


                            
                    }
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Sorular güncellendi")
                    self.tableView.reloadData()
                    self.activityind.stopAnimating()
                }
            }
        }
    }
    
    func getUserBilgileri(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: (currentUser?.objectId) ?? "0")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {

            } else {
                for object in objects! {
                    if let enerji_ = object.object(forKey: "Enerji") as? Double {
                        self.userEnerji = enerji_
                    }
                }
            }
        }
    }
    
    func getSoruAktiviteleri(){
        let query = PFQuery(className: "SoruAktiviteleri")
        query.whereKey("UserId", equalTo: PFUser.current())
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Kodu 1251!")
            } else {
                
                    self.soruAktiviteleriID.removeAll(keepingCapacity: false)
                    
                    if objects != nil {
                        for object in objects! {
                            if let soruid = object.object(forKey: "SoruId") as? PFObject {
                                self.soruAktiviteleriID.append(String(soruid.objectId!))
                                
                            }
                        }
                        self.getSorularFromParse()
                }
            }
        }
    }
    
    @objc func backButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SoruCell
        cell.lblXP.text = String(soruXPL[indexPath.row]) + " XP"
        cell.lblSoruDegeri.text =  String(soruDegeriL[indexPath.row]) + " ₺"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if soruNameArray.count > 10 {
            return 10
        }
        else {
            return soruNameArray.count
        }
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func activityIndCagir(){
        activityind.center = self.view.center
        activityind.hidesWhenStopped = true
        activityind.style = UIActivityIndicatorView.Style.large
        activityind.color = UIColor.black
        self.view.addSubview(activityind)
        activityind.startAnimating()
    
    }

}
