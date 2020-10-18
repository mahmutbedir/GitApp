//
//  ListViewController.swift
//  Gezi Rehberim
//
//  Created by Mac on 10.03.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var titleArray = [String]()
    var idArray = [UUID]()
    var chosenTitle = ""
    var chosenTitleID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

 /*
         Öncelikle table view ayarlarını yap
         ,UITableViewDelegate UITableViewDataSource ekle
         delegate ve dataSourceunu ekle
         sonranumberofRowinSection ve cellForRowAt fonksiyonlarını ekle
 */
        tblView.delegate = self
        tblView.dataSource = self
        
        // + butonu eklemek için
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { //Bu görünüm her görüdnüğünde çağrılır
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    @objc func getData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0
            {
                self.titleArray.removeAll(keepingCapacity: true) //listeyi temizledik duplicateler olmasın diye
                self.idArray.removeAll(keepingCapacity: true)
                
                for result in results as![NSManagedObject]
                {
                    if let title = result.value(forKey: "title") as? String{
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        self.idArray.append(id)
                    }
                    
                    tblView.reloadData() //Tableviewı yeniledik
                }
            }
        } catch  {
            print("Request error.")
        }
    }
    
    @objc func addButtonClicked(){
        chosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        chosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController"{
            let destinationVS = segue.destination as! ViewController
            destinationVS.selectedTitle = chosenTitle
            destinationVS.selectedTitleID = chosenTitleID
        }
            
    }

}
