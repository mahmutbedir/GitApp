//
//  ProfilViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse


class ProfilViewController: UIViewController {

    @IBOutlet weak var lblBakiye: UILabel!
    @IBOutlet weak var lblReferansCount: UILabel!
    @IBOutlet weak var lblAylikOdeme: UILabel!
    @IBOutlet weak var lblSonrakiSeviye: UILabel!
    @IBOutlet weak var lblReferanslarim: UILabel!
    @IBOutlet weak var lblBakiyemOdeme: UILabel!
    @IBOutlet weak var lblXPmKalan: UILabel!
    
    var refKodum = ""
    var refKodGirisi = ""
    var tf : UITextField?
    var reflerim = [String]()
    
    var minParaCekmeLimiti = 0
    var minGerekliRefAdet = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAyarlar()
        getReferanslarim()
        getUserBilgileri()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserBilgilerSelector), name: NSNotification.Name(rawValue: "getUserBilgilerSelector"), object: nil)
    }
    
    @objc func getUserBilgilerSelector() {
        getUserBilgileri()
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
                        self.lblXPmKalan.text = String(format: "%.0f", xp) + " XP / 5000 XP"
                    }
                    if let aylikOdeme = object.object(forKey: "Bakiye") as? Double {
                        self.lblAylikOdeme.text = String(format: "%.2f", aylikOdeme) + " ₺" + " / \(self.minParaCekmeLimiti) ₺"
                    }
                    if let bakiye = object.object(forKey: "Bakiye") as? Double {
                        self.lblBakiye.text = String(format: "%.2f", bakiye) + "₺"
                    }
                    if let refKodum_ = object.object(forKey: "ReferansKodum") as? String {
                        self.refKodum = String(refKodum_)
                    }
                    
                    self.lblReferanslarim.text = String(self.reflerim.count) + " / " + String(self.minGerekliRefAdet)
                }
            }
        }
    }
    @IBAction func refGirClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Referans Girişi", message: "6 haneli referans kodunu giriniz.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Çık", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Kod:"
            self.tf = textField
            //textField.isSecureTextEntry = false // for password input
        })
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default, handler: { (action) in

            
            if self.tf?.text?.count != 6 {
                self.makeAlert(titleInput: "Hata", messageInput: "Referans kodu 6 karakter olmalıdır!")
                return
            } else {
                let user = PFUser.current()
                user?["Referansim"] = self.tf?.text
                user?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Referans girişiniz tamamlanmıştır.")
                    }
                })
            }

        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func referanslarimClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnRefKodumClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Referans Kodu", message: refKodum, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Kopyala", style: .default, handler: { (action) in
            UIPasteboard.general.string = self.refKodum
            self.makeAlert(titleInput: "Başarılı", messageInput: "Referans kodunuz kopyalandı")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnVerileriGuncClicked(_ sender: Any) {
        makeAlert(titleInput: "Başarılı", messageInput: "Veriler güncellendi.")
        viewDidLoad()
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getReferanslarim(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("Referansim", equalTo: (currentUser?["ReferansKodum"]) ?? "0")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {

            } else {
                self.reflerim.removeAll(keepingCapacity: false)

                for object in objects! {
                    if let refAdi = object.object(forKey: "username") as? String {
                        self.reflerim.append(refAdi)
                    }
                }
            }
        }
    }
    
    func getAyarlar(){
        let any = "MinimumRefZorunlulugu"
        let query = PFQuery(className: "Ayarlar")
        query.whereKey("Konu", equalTo: any)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: "Ayarlar yüklenirken hata oluştu.")
            } else {
                for object in objects! {
                    if let minRef_ = object.object(forKey: "Adet") as? Double {
                        self.minGerekliRefAdet = Int(minRef_)
                    }

                }
            }
        }
        
        let any2 = "MinimumParaCekmeLimiti"
        let query2 = PFQuery(className: "Ayarlar")
        query2.whereKey("Konu", equalTo: any2)
        query2.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: "Ayarlar yüklenirken hata oluştu.")
            } else {
                for object in objects! {
                    if let minParaCekme_ = object.object(forKey: "Adet") as? Double {
                        self.minParaCekmeLimiti = Int(minParaCekme_)
                    }
                }
            }
        }
    }
}



