//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Mac on 6.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    var emailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        
        getDataFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore(){
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for doc in snapshot!.documents {
                        let docId = doc.documentID
                        self.documentIdArray.append(docId)
                        
                        if let postedBy = doc.get("postedBy") as? String {
                            self.emailArray.append(postedBy)
                        }
                        if let comment = doc.get("postComment") as? String {
                            self.userCommentArray.append(comment)
                        }
                        if let imageURL = doc.get("imageURL") as? String {
                            self.userImageArray.append(imageURL)
                        }
                        if let likes = doc.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                    }
                    self.tblView.reloadData()
                }
            }
        }
        
         
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.lblUserEmail.text = emailArray[indexPath.row]
        cell.lblComment.text = userCommentArray[indexPath.row]
        cell.lblLikeCount.text = String(likeArray[indexPath.row])
        cell.imgUserImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.lblDocumentId.text = documentIdArray[indexPath.row]
        return cell
    }

    @IBAction func btnLikeClicked(_ sender: Any) {
        
    }
}
