//
//  KayitOlViewController.swift
//  ExamMachine
//
//  Created by Mac on 23.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//
import CommonCrypto
import UIKit
import Parse

class KayitOlViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtAdSoyad: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtPassTekrar: UITextField!
    @IBOutlet weak var txtReferans: UITextField!
    @IBOutlet weak var segCinsiyet: UISegmentedControl!
    
    var activityind : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refKodu = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        txtTel.delegate = self
        txtUserName.delegate = self
    }
    @IBAction func btnKayitOlClicked(_ sender: Any) {
        
        if txtUserName.text != "" && txtEmail.text != "" && txtPass.text != "" && txtAdSoyad.text != "" && txtPassTekrar.text != "" && txtTel.text != "" {
            
            let user = PFUser()
            user.email = txtEmail.text!
            user["AdSoyad"] = txtAdSoyad.text!
            user.username = txtUserName.text!
            
            if (txtPass.text!.count < 6 && txtPassTekrar.text!.count < 6) {
                makeAlert(titleInput: "Hata", messageInput: "Şifre uzunluğu en az 6 karakter olmalı!")
                return
            }
            
            if txtTel.text!.count != 17 {
                makeAlert(titleInput: "Hata", messageInput: "Telefon numarasını hatalı girdiniz!")
                return
            } else {
                user["Telefon"] = txtTel.text!
            }
            
            if txtPass.text != txtPassTekrar.text {
                makeAlert(titleInput: "Hata", messageInput: "Şifreler uyuşmuyor!")
                return
            } else {
                user.password = txtPass.text!
                user["PW"] = txtPass.text!
            }
            
            user["DeviceID"] = UIDevice.current.identifierForVendor!.uuidString
            user["CihazTipi"] = "iOS"

            
            if txtReferans.text != "" {
                if let ref = txtReferans.text {
                    if txtReferans.text!.count != 6 {
                        makeAlert(titleInput: "Hata", messageInput: "Referans kodu uzunluğu 6 karakter olmalı!")
                        return
                    } else {
                        user["Referansim"] = ref
                        refKodu = ref
                    }
                }
            }

            
            if segCinsiyet.selectedSegmentIndex == 0 {
                user["Cinsiyet"] = 0
            } else if segCinsiyet.selectedSegmentIndex == 1 {
                user["Cinsiyet"] = 1
            } else if segCinsiyet.selectedSegmentIndex == 2 {
                user["Cinsiyet"] = 2
            }
            
            var rnd = randomString(6)
            user["ReferansKodum"] = rnd
            
            
            self.activityIndCagir()
            user.signUpInBackground { (success, error) in
                if error != nil{
                    if error?.localizedDescription == "Account already exists for this email address." {
                        self.makeAlert(titleInput: "Hata", messageInput: "Bu email adresi zaten kayıtlıdır.")
                    } else {
                        self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Kayıt olma hatası!")
                    }
                } else {
                    self.activityind.stopAnimating()
                    print("OK")
                    self.referansiArtir()
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Ad Soyad / Email / Şifre / Kullanıcı Adı dolu olmalı!")
        }
        
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func referansiArtir() {

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
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "X (XXX) XXX XX XX", phone: newString)
            return false
        }
        
        if textField == txtUserName {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789qwertyuopasdfghjklizxcvbnm_QWERTYUOPASDFGHJKLIZXCVBNM")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func activityIndCagir(){
        activityind.center = self.view.center
        activityind.hidesWhenStopped = true
        activityind.style = UIActivityIndicatorView.Style.large
        activityind.color = UIColor.black
        self.view.addSubview(activityind)
        activityind.startAnimating()
    
    }
    
    func sha256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    func sha256(_ str: String) -> String? {
        guard
            let data = str.data(using: String.Encoding.utf8),
            let shaData = sha256(data)
            else { return nil }
        let rc = shaData.base64EncodedString(options: [])
        return rc
    }
    
    func SifreleBakalim() {
        
    }
    
}
