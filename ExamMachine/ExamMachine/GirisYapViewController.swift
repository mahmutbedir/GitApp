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
    
    var activityind : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

    }
    @IBAction func GirisYapClicked(_ sender: Any) {
        
        if txtEmail.text != "" && txtPass.text != "" {
            self.activityIndCagir()
            PFUser.logInWithUsername(inBackground: txtEmail.text!, password: txtPass.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Giriş yapılamadı!")
                } else {
                    self.activityind.stopAnimating()
                    print("OK")
                    self.performSegue(withIdentifier: "toTabBarController", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Email ve Şifre dolu olmalı")
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
    
    func activityIndCagir(){
        activityind.center = self.view.center
        activityind.hidesWhenStopped = true
        activityind.style = UIActivityIndicatorView.Style.large
        activityind.color = UIColor.black
        self.view.addSubview(activityind)
        activityind.startAnimating()
    }

}
