//
//  OdemeTalebiVC.swift
//  ExamMachine
//
//  Created by Mac on 10.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class OdemeTalebiVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtisimSoyisim: UITextField!
    @IBOutlet weak var txtBankaAdi: UITextField!
    @IBOutlet weak var txtIban: UITextField!
    @IBOutlet weak var txtCekilecekTutar: UITextField!

    var bankaListesi = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        txtIban.delegate = self
        txtCekilecekTutar.delegate = self
        //txtBankaAdi.delegate  = self
        //getBankalar()
    }

    @IBAction func btnParaTalebi(_ sender: Any) {
        if txtisimSoyisim.text != "" && txtIban.text != "" && txtCekilecekTutar.text != "" && txtBankaAdi.text != ""{

            let odemeTalebi = PFObject(className: "OdemeTalepleri")
            odemeTalebi["UserId"] = PFUser.current()
            odemeTalebi["UserAdSoyad"] = txtisimSoyisim.text!
            odemeTalebi["IBAN"] = txtIban.text!
            odemeTalebi["Tutar"] = txtCekilecekTutar.text!
            odemeTalebi["BankaAdi"] = txtBankaAdi.text!
            
            var rnd = randomString(5)
            odemeTalebi["KayitNo"] = rnd

            odemeTalebi.saveInBackground { (success, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Talep oluşturma hatası!")
                } else {
                    print("OK")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Banka Iban ve Tutar dolu olmalı")
        }
    }
    
    
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getBankalar(){
        let query = PFQuery(className: "Bankalar")
        query.findObjectsInBackground { (objects, error) in
                if error != nil {

                } else {
                    self.bankaListesi.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let bankaAdi = object.object(forKey: "BankaAdi") as? String {
                                    self.bankaListesi.append(bankaAdi)
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == txtIban || textField == txtCekilecekTutar {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    //func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //return 1
    //}
    
    //func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return bankaListesi.count
    //}
    
    //func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //self.view.endEditing(true)
        //return bankaListesi[row]
    //}
    
    //func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.txtBankaAdi.text = self.bankaListesi[row]
        //self.selectBankaAdi.isHidden = true
    //}
    
    //func textFieldDidBeginEditing(_ textField: UITextField) {
        //if textField == self.txtBankaAdi {
            //self.selectBankaAdi.isHidden = false
            //textField.endEditing(true)
        //}
    //}
    
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
