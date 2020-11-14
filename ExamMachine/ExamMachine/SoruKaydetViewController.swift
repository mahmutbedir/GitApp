//
//  SoruKaydetViewController.swift
//  ExamMachine
//
//  Created by Mac on 24.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class SoruKaydetViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txtA: UITextField!
    @IBOutlet weak var txtB: UITextField!
    @IBOutlet weak var txtC: UITextField!
    @IBOutlet weak var txtD: UITextField!
    @IBOutlet weak var txtDogruCevap: UITextField!
    @IBOutlet weak var lblXP: UITextField!
    @IBOutlet weak var lblKurus: UITextField!
    
    @IBOutlet weak var txtViewSoru: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        lblXP.delegate = self
        lblKurus.delegate = self
        txtViewSoru.delegate = self
    }

    @IBAction func btnKaydet(_ sender: Any) {
        if(txtViewSoru.text == "" || txtA.text == "" || txtB.text == "" || txtC.text == "" || txtD.text == "" || txtDogruCevap.text == "" || lblXP.text == "" || lblKurus.text == "")
        {
            makeAlert(titleInput: "Boş alanlar var", messageInput: "Tüm alanları doldurunuz")
        } else {
            let object = PFObject(className: "Sorular")
                        
            let xpp:Int? = Int(lblXP.text!)
            if (xpp! > 25 || xpp! < 0){
                makeAlert(titleInput: "Error", messageInput: "XP degeri 0 - 25 XP arasında olmalı!")
                return
            } else {
                object["XpDegeri"] = Int(lblXP.text!)
            }
            
            if(txtViewSoru.text.count > 150) {
                makeAlert(titleInput: "Error", messageInput: "Soru karakter sayısı 150 karakteri geçmemeli!")
                return
            } else {
                object["Soru"] = txtViewSoru.text!
            }
            
            if (txtA.text!.count > 30 || txtB.text!.count > 30 || txtC.text!.count > 30 || txtD.text!.count > 30) {
                makeAlert(titleInput: "Error", messageInput: "Cevap karakter sayısı 30 karakteri geçmemeli!")
                return
            } else {
                object["A"] = txtA.text!
                object["B"] = txtB.text!
                object["C"] = txtC.text!
                object["D"] = txtD.text!
            }
            
            if (txtDogruCevap.text != "A" && txtDogruCevap.text != "B" && txtDogruCevap.text != "C" && txtDogruCevap.text != "D"
                    && txtDogruCevap.text != "a" && txtDogruCevap.text != "b" && txtDogruCevap.text != "c" && txtDogruCevap.text != "d")
            
            {
                self.makeAlert(titleInput: "Hata", messageInput: "Yanıt olarak A/B/C/D seçilmeli!")
                return
            } else {
                if txtDogruCevap.text! == "a" { object["DogruCevap"] = "A" }
                else if txtDogruCevap.text! == "b" { object["DogruCevap"] = "B" }
                else if txtDogruCevap.text! == "c" { object["DogruCevap"] = "C" }
                else if txtDogruCevap.text! == "d" { object["DogruCevap"] = "D" }
                else {
                    object["DogruCevap"] = txtDogruCevap.text!
                }
            }
            
            let kurus:Int? = Int(lblKurus.text!)
            if (kurus! > 25 || kurus! < 0){
                makeAlert(titleInput: "Hata", messageInput: "Soru degeri 0 - 25 kuruş arasında olmalı!")
                return
            } else {
                object["Kazanc"] = Double(lblKurus.text!)! / 100
            }
            
            object["UserId"] = PFUser.current()
            
            object.saveInBackground { (success, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Soru ekleme hatası")
                } else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: error?.localizedDescription ?? "Soru eklendi, kontrol edilecektir")
                    self.alanlariSifirla()
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        txtViewSoru.text = ""
    }
    
    func textField(_ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool {
      let invalidCharacters =
        CharacterSet(charactersIn: "0123456789").inverted
      return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    
    func alanlariSifirla(){
        txtViewSoru.text = "Soru : "
        txtA.text = ""
        txtB.text = ""
        txtC.text = ""
        txtD.text = ""
        txtDogruCevap.text = ""
        lblXP.text = ""
        lblKurus.text = ""
    }
    
    
}
