//
//  EntranceViewController.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class EntranceViewController: UIViewController {

    @IBOutlet weak var intraIdUITextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        UserInformation.shared.id = self.intraIdUITextField?.text
    }

    
}
