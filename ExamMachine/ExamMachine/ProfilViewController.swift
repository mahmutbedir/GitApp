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

    override func viewDidLoad() {
        super.viewDidLoad()

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
                        self.lblAylikOdeme.text = String(format: "%.2f", aylikOdeme) + " ₺" + " / 200 ₺"
                    }
                    if let bakiye = object.object(forKey: "Bakiye") as? Double {
                        self.lblBakiye.text = String(format: "%.2f", bakiye) + "₺"
                    }
                    if let refKodu = object.object(forKey: "ReferansKodum") as? String {
                        self.refKodum = refKodu
                    }
                }
            }
        }
    }
    @IBAction func refGirClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Referans Girişi", message: "8 haneli referans kodunu giriniz.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Çık", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Kod:"
            self.tf = textField
            //textField.isSecureTextEntry = false // for password input
        })
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default, handler: { (action) in
            let user = PFUser.current()
            user?["Referansim"] = self.tf?.text
            user?.saveInBackground(block: { (success, error) in
                if error != nil {
                    
                } else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Referans girişiniz tamamlanmıştır.")
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func referanslarimClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnRefKodumClicked(_ sender: Any) {
        makeAlert(titleInput: "Referans Kodunuz : ", messageInput: refKodum)
    }
    
    
    @IBAction func btnVerileriGuncClicked(_ sender: Any) {
        viewDidLoad()
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
