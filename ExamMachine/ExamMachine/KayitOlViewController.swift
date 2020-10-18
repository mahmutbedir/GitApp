//
//  KayitOlViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class KayitOlViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtAdSoyad: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtPassTekrar: UITextField!
    @IBOutlet weak var txtReferans: UITextField!
    @IBOutlet weak var segCinsiyet: UISegmentedControl!
    
    var refKodu = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtTel.delegate = self
    }
    @IBAction func btnKayitOlClicked(_ sender: Any) {
        
        if txtEmail.text != "" && txtPass.text != "" && txtAdSoyad.text != "" && txtPassTekrar.text != "" {

            let user = PFUser()
            user.email = txtEmail.text!
            user.username = txtAdSoyad.text!
            
            if (txtPass.text?.count ?? 0 < 6 && txtPassTekrar.text?.count ?? 0 < 6) {
                makeAlert(titleInput: "Hata", messageInput: "Şifre uzunluğu en az 6 karakter olmalı!")
                return
            }
            
            if txtPass.text != txtPassTekrar.text {
                makeAlert(titleInput: "Hata", messageInput: "Şifreler uyuşmuyor!")
                return
            } else {
                user.password = txtPass.text!
            }
            if let ref = txtReferans.text {
                user["Referansim"] = ref
                refKodu = ref
            }
            if segCinsiyet.selectedSegmentIndex == 0 {
                user["Cinsiyet"] = 0
            } else {
                user["Cinsiyet"] = 1
            }
            
            var rnd = randomString(8)
            user["ReferansKodum"] = rnd
            
            
            
            user.signUpInBackground { (success, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    print("OK")
                    self.referansiArtir()
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Ad Soyad / Email / Şifre ??")
        }
        
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func referansiArtir() {
        
        let query = PFQuery(className: "_User")
        query.whereKey("ReferansKodum", equalTo: String(refKodu) )
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil {

            } else {
                for object in objects! {
                    var us = (object) as! PFUser
                    us.objectId = object.objectId
                    us.incrementKey("ReferansSayim", byAmount: NSNumber(value : 1.00))
                    us.saveInBackground { (success, error) in
                        if error != nil {
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Hata Kodu 2000")
                        } else {
                            print("success")
                        }
                    }
                }

            }
        }
    }
    
    @IBAction func btnGirisYapClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toKayitolGirisYap", sender: nil)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == txtTel {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
}
