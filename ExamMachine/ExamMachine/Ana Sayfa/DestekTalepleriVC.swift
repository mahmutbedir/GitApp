//
//  DestekTalepleriVC.swift
//  ExamMachine
//
//  Created by Mac on 10.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class DestekTalepleriVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var txtBaslik: UITextField!
    @IBOutlet weak var txtMesaj: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var destekBaslik = [String]()
    var destekMesaj = [String]()
    var destekKayitNo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        getTaleplerim()
    }
    
    @IBAction func btnGonderClicked(_ sender: Any) {
        if txtBaslik.text != "" || txtMesaj.text != "" {

            let destekTalebi = PFObject(className: "DestekTalepleri")
            
            
            destekTalebi["UserId"] = PFUser.current()
            destekTalebi["Baslik"] = txtBaslik.text!
            destekTalebi["Mesaj"] = txtMesaj.text!
                
            let rnd = randomString(5)
            destekTalebi["KayitNo"] = rnd

            destekTalebi.saveInBackground { (success, error) in
            if error != nil{
                self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Destek talebi oluşturma hatası!")
            } else {
                self.makeAlert(titleInput: "Talebiniz kaydedildi.", messageInput: "Destek ekibi 48 saat içerisinde yanıtlayacaktır. Bu sürede aynı durum için tekrar kayıt açmayınız.")
                    //self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Başlık ve Mesaj dolu olmalı")
        }
        getTaleplerim()
    }
    
    @IBAction func btnSikSorulanMesajlar(_ sender: Any) {
        var konu_ = "SikSorulanSorularLinki"
        let query = PFQuery(className: "Ayarlar")
        query.whereKey("Konu", equalTo: konu_)
        query.findObjectsInBackground { (objects, error) in
                if error != nil {

                } else {
                    
                    for object in objects! {
                        if let link_ = object.object(forKey: "Link") as? String {
                            guard let url = URL(string: link_) else { return }
                            UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = destekBaslik[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destekBaslik.count
    }
    
    func getTaleplerim() {
        let currentUser = PFUser.current()
        let query = PFQuery(className: "DestekTalepleri")
        query.whereKey("UserId", equalTo: currentUser)
        query.findObjectsInBackground { (objects, error) in
                if error != nil {

                } else {
                    self.destekBaslik.removeAll(keepingCapacity: false)
                    self.destekMesaj.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let Baslik = object.object(forKey: "Baslik") as? String {
                            if let Mesaj = object.object(forKey: "Mesaj") as? String {
                                if let KayitNo = object.object(forKey: "KayitNo") as? String {
                                    self.destekBaslik.append( KayitNo + " | " +  Baslik + " | " + Mesaj)
                                    self.destekMesaj.append(Mesaj)
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
    
    func randomString(_ n: Int) -> String
    {
        let digits = "ABCDEF1234567890"
        var result = ""

        for _ in 0..<n {
            result += String(digits.randomElement()!)
        }

        return result
    }
}
