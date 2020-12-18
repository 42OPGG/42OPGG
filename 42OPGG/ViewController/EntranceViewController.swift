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
    @IBOutlet weak var goToNextViewControllerUIButton: UIButton!
    @IBOutlet weak var checkIfSearchableUIButton: UIButton!
    
    var piscineData: PiscineAPIResponse?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gon_background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.goToNextViewControllerUIButton.isEnabled = false
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkSearchable(timer:)), userInfo: nil, repeats: true)
        
        self.intraIdUITextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func checkSearchable(timer: Timer) {
        guard let piscineData = self.piscineData
            else {return}
        print("piscineData.success =\(piscineData.success)")
        if piscineData.success == "true" {
            self.goToNextViewControllerUIButton.isEnabled = true
        }
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        self.piscineData = nil
        self.goToNextViewControllerUIButton.isEnabled = false
    }
    
    

    
    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        UserInformation.shared.id = self.intraIdUITextField?.text
    }

    func showAlertController(reason: String) {
            let alertController: UIAlertController
            alertController = UIAlertController(title: "Error", message: reason, preferredStyle: UIAlertController.Style.alert)
            
            let okAction: UIAlertAction
            okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            alertController.addAction(okAction)

            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: {
                    print("alert: \(reason)")
                })
            }

    }
    
    @IBAction func touchUpCheckButton(_ sender: UIButton) {
        
        if self.intraIdUITextField.text == "" {
            self.showAlertController(reason: "인트라아이디를 입력하세요.")
            return
        }
        
        guard let intraId = self.intraIdUITextField.text
            else {return}
        
        guard let getPiscineAPIurl: URL = URL(string: "https://api.jiduckche.com/api/piscine/" + intraId)
             else {return}
         let getPiscineAPISession: URLSession = URLSession(configuration: .default)
         let getPiscineAPIDataTask: URLSessionDataTask = getPiscineAPISession.dataTask(with: getPiscineAPIurl) {
             (data: Data?, reponse: URLResponse?, error: Error?) in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }
             guard let data = data
                 else {return}
             do {
                 let apiResponse: PiscineAPIResponse = try JSONDecoder().decode(PiscineAPIResponse.self, from: data)
                print("apiResponse.success: \(apiResponse.success)")
                self.piscineData = apiResponse
                 if apiResponse.success == "false" {
                     self.showAlertController(reason: "해당 id로 조회할 수 있는 사람이 없습니다.")
                 }

             } catch (let err) {
                self.showAlertController(reason: "해당 id로 조회할 수 있는 사람이 없습니다.")
                print(err.localizedDescription)
             }
         }
        getPiscineAPIDataTask.resume()
    }
}
