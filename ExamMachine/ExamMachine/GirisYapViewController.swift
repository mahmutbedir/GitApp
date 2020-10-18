//
//  GirisYapViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse

class GirisYapViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnGirisYap: UIButton!
    @IBOutlet weak var btnKayitOl_: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func GirisYapClicked(_ sender: Any) {
        
        if txtEmail.text != "" && txtPass.text != "" {
            PFUser.logInWithUsername(inBackground: txtEmail.text!, password: txtPass.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    print("OK")
                    self.performSegue(withIdentifier: "toTabBarController", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Email / Şifre ??")
        }
    }
    @IBAction func KayitOlClicked(_ sender: Any) {
        performSegue(withIdentifier: "toGiris_KayitOlController", sender: nil)
    }
    @IBAction func YardimAlClicked(_ sender: Any) {
        performSegue(withIdentifier: "toYardimAl", sender: nil)
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
