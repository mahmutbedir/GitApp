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
    
    var secilenSoruId = ""
    var dogruCevap = ""
    var hakedisXP = 0.00
    var hakedisTL = 0.00
    
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")

        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        getDataFromSorular()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") //Yayınlamadn önce değiştir
        let request = GADRequest()
        interstitial.load(request)

    }
    
    func reloadd(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
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
                }
            }
        }
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
         GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
     }

     

     func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        currency += 100
        makeAlert(titleInput: String(currency), messageInput: String(currency))
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
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        //let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default, handler: { (action) in
            self.reklamIzleIkili()
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
        
        object.saveInBackground { (success, error) in
            if error != nil {
                
            } else {
                print("Success")
                self.useraPuanEkle(xp: self.hakedisXP, kazanc: self.hakedisTL)
                //self.getUserBilgileri()
                self.reloadd()
                //self.tabBarController?.selectedIndex = 1
            }
        }
    }
    
    func useraPuanEkle(xp: Double, kazanc: Double){
        let user = PFUser.current()
        user?.incrementKey("Bakiye", byAmount: NSNumber(value : kazanc))
        user?.incrementKey("XP", byAmount: NSNumber(value : xp))
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
    
    func reklamIzleIkili(){
        reklamGelsin()
        sleep(5)
        reklamGelsin()

    }
    
    func reklamGelsin() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
              GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
          }
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
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        makeAlert(titleInput: reward.type, messageInput: "\(reward.amount).")
        acilanPageiGizle()
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
       makeAlert(titleInput: "Rewarded ad presented", messageInput: "Rewarded ad presented")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad dismissed.")
        makeAlert(titleInput: "Rewarded ad dismissed.", messageInput: "Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
        makeAlert(titleInput: "Rewarded ad failed to present.", messageInput: "Rewarded ad failed to present.")
    }
    
}
