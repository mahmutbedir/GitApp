//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Mac on 21.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var imgUserImageView: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDocumentId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnLikeClick(_ sender: Any) {
        let firestore = Firestore.firestore()
        if let likeCount = Int(lblLikeCount.text!)
        {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestore.collection("Posts").document(lblDocumentId.text!).setData(likeStore, merge: true)
        }
    }
}
