//
//  AyarlarViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class AyarlarViewController: UIViewController {

    @IBOutlet weak var uiSwitch: UISwitch!
    
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        //let request = GADRequest()
        //interstitial.load(request)
        
        uiSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @IBAction func btnYarismaKurallariClicked(_ sender: Any) {
        let any = "YarismaKurallari"
        let query = PFQuery(className: "Ayarlar")
        query.whereKey("Konu", equalTo: any)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: "Ayarlar yüklenirken hata oluştu.")
            } else {
                for object in objects! {
                    if let metin = object.object(forKey: "Metin") as? String {
                        self.makeAlert(titleInput: "Yarışma Kuralları", messageInput: metin)
                    }

                }
            }
        }
    }
    
    @objc func switchChanged(mySwitch : UISwitch){
        let value = mySwitch.isOn
        if value == true {
            let user = PFUser.current()
            user?["BildirimDurumu"] = true
            user?.saveInBackground(block: { (success, error) in
                if error != nil {
                    
                } else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Bildirimleriniz aktifleştirilmiştir.")
                }
            })
        } else {
            
                let user = PFUser.current()
                user?["BildirimDurumu"] = false
                user?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Bildirimleriniz kapatılmıştır.")
                    }
                })
        }
    }
            

    @IBAction func CikisYapClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Logout hatası.")
            }
            else{
                self.performSegue(withIdentifier: "toGirisYapController", sender: nil)
            }
        }
    }
    
    @IBAction func btnSoruEkle(_ sender: Any) {
        //if interstitial.isReady {
        //  interstitial.present(fromRootViewController: self)
        //} else {
        //  print("Ad wasn't ready")
        //}

        performSegue(withIdentifier: "toSoruEkle", sender: nil)
    }
    
    @IBAction func bildirimlerChanged(_ sender: Any) {
        
    }
    
    @IBAction func btnReflerGuncelleClicked(_ sender: Any) {
    }
    
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
