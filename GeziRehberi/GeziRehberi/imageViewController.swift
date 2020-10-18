//
//  imageViewController.swift
//  GeziRehberi
//
//  Created by Mac on 18.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class imageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblYer: UILabel!
    
    var selectedyerName = ""
    var selectedyerGorsel = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.image = selectedyerGorsel
        lblYer.text = selectedyerName
    }
    
}
