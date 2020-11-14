//
//  YardimAlVC.swift
//  ExamMachine
//
//  Created by Mac on 13.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class YardimAlVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }

    @IBAction func btnSifremiUnuttumClicked(_ sender: Any) {
        if txtEmail.text != "" {
            let validmi = isValidEmail(txtEmail.text!)
            if validmi == true {
                PFUser.requestPasswordResetForEmail(inBackground: txtEmail.text!) { (success, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Şifre sıfırlama hatası")
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Sıfırlama emaili gönderildi.")
                    }
                }
            } else {
                makeAlert(titleInput: "Hata", messageInput: "Email hatalı!")
            }

        } else {
            makeAlert(titleInput: "Hata", messageInput: "Email dolu olmalı")
        }

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func btnGirisYapClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnKayitOlClicked(_ sender: Any) {
        performSegue(withIdentifier: "toYardimAldanKayitOl", sender: nil)
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
