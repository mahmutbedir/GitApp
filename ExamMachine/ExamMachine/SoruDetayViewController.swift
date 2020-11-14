//
//  SoruDetayViewController.swift
//  ExamMachine
//
//  Created by Mac on 24.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class SoruDetayViewController: UIViewController, GADRewardBasedVideoAdDelegate {

    var currency = 0
    
    var interstitial: GADInterstitial!

    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var txtSoru: UITextView!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var lblCurrency: UILabel!
    
    var secilenSoruId = ""
    var dogruCevap = ""
    var hakedisXP = 0.00
    var hakedisTL = 0.00
    
    
    let user = PFUser.current()
    
    var counter = 20
    
    weak var timer: Timer?
    
    var activityind : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndCagir()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Back.png")!)
        getDataFromSorular()
        
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self

        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-6070716528243368/4729133255")


        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") //Yayınlamadn önce değiştir
        //let request = GADRequest()
        //interstitial.load(request)
        txtSoru.backgroundColor = UIColor.white

    }
    
    func reloadd(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    func userGuncelleSelector(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserBilgilerSelector"), object: nil)
    }
    
    func getDataFromSorular() {
        let query = PFQuery(className: "Sorular")
        query.whereKey("objectId", equalTo: secilenSoruId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
            } else {
                if objects != nil {
                    let secilisoruobject = objects![0]
                    
                    if let dogruYanit = secilisoruobject.object(forKey: "DogruCevap") as? String {
                        self.dogruCevap = dogruYanit
                    }
                    
                    if let soruName = secilisoruobject.object(forKey: "Soru") as? String {
                        self.txtSoru.text = soruName
                    }
                    
                    if let xp = secilisoruobject.object(forKey: "XpDegeri") as? Double {
                        self.hakedisXP = xp
                    }
                    
                    if let tl = secilisoruobject.object(forKey: "Kazanc") as? Double {
                        self.hakedisTL = tl
                    }
                    
                    if let A = secilisoruobject.object(forKey: "A") as? String {
                        self.btnA.setTitle("A : \(A)", for: .normal)
                    }
                    
                    if let B = secilisoruobject.object(forKey: "B") as? String {
                        self.btnB.setTitle("B : \(B)", for: .normal)
                    }
                    
                    if let C = secilisoruobject.object(forKey: "C") as? String {
                        self.btnC.setTitle("C : \(C)", for: .normal)
                    }
                    
                    if let D = secilisoruobject.object(forKey: "D") as? String {
                        self.btnD.setTitle("D : \(D)", for: .normal)
                    }
                    self.activityind.stopAnimating()
                }
            }
        }
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
         
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")  // TEST
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-6070716528243368/4729133255")

        self.dismiss(animated: false, completion: nil)
        self.reloadd()
        
     }

     

     func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        currency += 100
        //lblCurrency.text = String("\(hakedisXP) XP | \(hakedisTL) TL" )
        useraPuanEkle(xp: hakedisXP, kazanc: hakedisTL)
     }
    
    @IBAction func AClicked(_ sender: Any) {
        if dogruCevap == "A" {
            makeAlert(titleInput: "Tebrikler!", messageInput: "Soruyu doğru yanıtlayıp, ödülü kazandınız!")
            

        } else {
            makeAlert(titleInput: "Yanlış cevap :(", messageInput: "Diğer sorular ile devam edebilirsin.")
        }
        soruCozulduKaydiOlustur(secilenSoruid: secilenSoruId, userCevap: "A")

    }
    
    @IBAction func BClicked(_ sender: Any) {
        if dogruCevap == "B" {
            makeAlert(titleInput: "Tebrikler!", messageInput: "Soruyu doğru yanıtlayıp, ödülü kazandınız!")
        } else {
            makeAlert(titleInput: "Yanlış cevap :(", messageInput: "Diğer sorular ile devam edebilirsin.")
        }
        soruCozulduKaydiOlustur(secilenSoruid: secilenSoruId, userCevap: "B")
    }
    
    @IBAction func CClicked(_ sender: Any) {
        if dogruCevap == "C" {
            makeAlert(titleInput: "Tebrikler!", messageInput: "Soruyu doğru yanıtlayıp, ödülü kazandınız!")
        } else {
            makeAlert(titleInput: "Yanlış cevap :(", messageInput: "Diğer sorular ile devam edebilirsin.")
        }
        soruCozulduKaydiOlustur(secilenSoruid: secilenSoruId, userCevap: "C")
    }
    
    @IBAction func DClicked(_ sender: Any) {
        if dogruCevap == "D" {
            makeAlert(titleInput: "Tebrikler!", messageInput: "Soruyu doğru yanıtlayıp, ödülü kazandınız!")
        } else {
            makeAlert(titleInput: "Yanlış cevap :(", messageInput: "Diğer sorular ile devam edebilirsin.")
        }
        soruCozulduKaydiOlustur(secilenSoruid: secilenSoruId, userCevap: "D")
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        stopTimer()
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        //let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            if titleInput == "Tebrikler!"{
                self.reklamGelsin()
            } else if titleInput == "Bir hata oluştu!" {
                return
            } else if titleInput == "Süre doldu" {
                self.dismiss(animated: false, completion: nil)
                self.reloadd()
            }
            else {
                self.dismiss(animated: false, completion: nil)
                self.reloadd()
            }
            //self.dismiss(animated: false, completion: nil)
            
            //self.reloadd()
        }))

        self.present(alert, animated: true, completion: nil)

    }
    
    func soruCozulduKaydiOlustur(secilenSoruid : String, userCevap : String)
    {
        if dogruCevap != userCevap {
            hakedisTL = 0
            hakedisXP = 0
        }
        
        let object = PFObject(className: "SoruAktiviteleri")
        object["UserId"] = PFUser.current()
        object["SoruId"] = PFObject(withoutDataWithClassName: "Sorular", objectId: secilenSoruid)
        object["UserCevap"] = userCevap
        object["DogruCevap"] = dogruCevap
        object["HakedisXP"] = hakedisXP
        object["HakedisTL"] = hakedisTL
        object["RefKodu"] = PFUser.current()!["Referansim"]
        object.saveInBackground { (success, error) in
            if error != nil {
                
            } else {
                print("Success")
                
                //self.reloadd()
            }
        }
    }
    
    func useraPuanEkle(xp: Double, kazanc: Double){
        let user = PFUser.current()
        user?.incrementKey("Bakiye", byAmount: NSNumber(value : hakedisTL))
        user?.incrementKey("XP", byAmount: NSNumber(value : hakedisXP))
        user?.incrementKey("Enerji", byAmount: -1.00)
        user?.saveInBackground(block: { (success, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Hata")
            } else {
                print("Başarılı")
                self.userGuncelleSelector()
            }
        })
    }
    
    func getUserBilgileri(){
        let currentUser = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: (currentUser?.objectId) ?? "0")
        print(String(currentUser?.objectId ?? ""))
        print("5")
        query.getObjectInBackground(withId: String(currentUser?.objectId ?? "0")) { (objects, error) in
            if error != nil {

            } else {
                    if let bakiye = objects?.object(forKey: "Bakiye") as? Double {
                        print(String(bakiye) + " ₺")
                    }
            }
        }
   }
    
    
    @IBAction func btnReklamIzle(_ sender: Any) {
        reklamGelsin()
        sleep(5)
        reklamGelsin()
    }

    func reklamGelsin() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
              GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        } else {
            makeAlert(titleInput: "Bir hata oluştu!", messageInput: "Tekrar çözebilir misiniz?")
            return
        }
    }
    
    func reklamGelsinIkili(){
        reklamGelsin()
        sleep(5)
        reklamGelsin()
    }
    
    func acilanPageiGizle(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loadingAnim() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnGeriDonClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      currency += 100
        lblCurrency.text = String(currency)
    }
    
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-6070716528243368/4729133255")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
    
    @objc func updateCounter() {
        
        
        if counter > 0 {
            //print("\(counter) seconds to the end of the world")
            lblTimer.text = String(counter)
            counter -= 1
        } else {
            lblTimer.text = "Süre doldu."
            stopTimer()
            makeAlert(titleInput: "Süre doldu", messageInput: "Daha hızlı olmalısın")
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }
    deinit {
        stopTimer()
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
