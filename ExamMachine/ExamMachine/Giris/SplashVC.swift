//
//  SplashVC.swift
//  ExamMachine
//
//  Created by Mac on 13.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "toSplashtoGiris", sender: nil)

    }
}
