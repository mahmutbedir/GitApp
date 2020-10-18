//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Mac on 25.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtPlace: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtatmosphere: UITextField!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgSelect.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgSelect.addGestureRecognizer(gestureRecognizer)
        	
    }
    @IBAction func btnNextClicked(_ sender: Any) {
        
        if txtPlace.text != "" && txtType.text != "" && txtatmosphere.text != "" {
            if let chosenImage = imgSelect.image {
                let placeModel = Placemodel.sharedInstance
                placeModel.placeName = txtPlace.text!
                placeModel.placeType = txtType.text!
                placeModel.placeAtmosphere = txtatmosphere.text!
                placeModel.placeImage = chosenImage
                
                
            }
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Place / Type / Atmosphere ??", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgSelect.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
