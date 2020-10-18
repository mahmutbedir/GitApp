//
//  MainViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblAdSoyad: UILabel!
    @IBOutlet weak var lblmail: UILabel!
    @IBOutlet weak var imgResim: UIImageView!
    @IBOutlet weak var lblBakiye: UILabel!
    @IBOutlet weak var lblXP: UILabel!
    
    var bilgiBaslik = [String]()
    var bilgiAciklama = [String]()
    var bilgiGorsel = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserBilgileri()
        getBilgilendirmelerFromParse()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bilgiBaslik[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bilgiAciklama.count
    }
    
    func getUserBilgileri(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: (currentUser?.objectId) ?? "0")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {

            } else {

                for object in objects! {
                    if let xp = object.object(forKey: "XP") as? Double {
                        self.lblXP.text = String(format: "%.0f", xp) + " XP"
                    }
                    if let emaill = object.object(forKey: "email") as? String {
                        self.lblmail.text = emaill
                    }
                    if let username = object.object(forKey: "username") as? String {
                        
                        self.lblAdSoyad.text = username
                    }
                    if let bakiye = object.object(forKey: "Bakiye") as? Double {
                        self.lblBakiye.text = String(format: "%.2f", bakiye) + " ₺"
                    }
                }
            }
        }
    }
    
    func getBilgilendirmelerFromParse() {
        let query = PFQuery(className: "Bilgilendirmeler")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Bilgilendirme hatası")
            } else {
                self.bilgiBaslik.removeAll(keepingCapacity: false)
                self.bilgiAciklama.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    if let basName = object.object(forKey: "Baslik") as? String {
                        if let bilgiId = object.objectId as? String {
                            self.bilgiBaslik.append(basName)
                            self.bilgiAciklama.append(bilgiId)
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
    }
    
    @IBAction func btnVerileriGuncelleClick(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func btnGorevlerClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func btnOdemeTalebiClicked(_ sender: Any) {
        performSegue(withIdentifier: "toOdemeTalebiVC", sender: nil)
    }
    
    @IBAction func btnOdemeTaleplerim(_ sender: Any) {
        performSegue(withIdentifier: "toOdemeTaleplerim", sender: nil)
    }
    
    @IBAction func btnDestekTalepleri(_ sender: Any) {
        performSegue(withIdentifier: "toDestekTalebi", sender: nil)
    }
    
    @IBAction func btnGecmisSorular(_ sender: Any) {
        performSegue(withIdentifier: "toHareketlerim", sender: nil)
    }
}
