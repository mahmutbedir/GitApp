//
//  DetailsVS.swift
//  ArtBook
//
//  Created by Mac on 26.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CoreData

class DetailsVS: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtArtist: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var chosenPainting = ""
    var chosenPaitingID : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenPainting != ""
        {
            btnSave.isEnabled = false //isHidden Gizler
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = chosenPaitingID?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                 let results = try context.fetch(fetchRequest)
                if results.count > 0
                {
                    for result in results as! [NSManagedObject]
                    {
                        if let name = result.value(forKey: "name") as? String{
                            txtName.text = name
                        }
                        if let artist = result.value(forKey: "artist") as? String{
                            txtArtist.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int{
                            txtYear.text = String(year)
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            } catch {
            }
        }
        else{
            txtName.text = ""
            txtYear.text = ""
            txtArtist.text = ""
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        newPainting.setValue(txtName.text, forKey: "name")
        newPainting.setValue(txtArtist.text, forKey: "artist")
        
        if let year = Int(txtYear.text!){
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.4)
        
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("save")
        } catch  {
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    

}
