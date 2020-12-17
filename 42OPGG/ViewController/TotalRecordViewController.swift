//
//  TotalRecordViewController.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class TotalRecordViewController: UIViewController {

    @IBOutlet weak var totalRecordTableView: UITableView!

    var projects: [String] = []
    var correctedLogs: [CorrectedLog] = []
    var piscineLog: PiscineLog?
    
    
    @IBAction func touchUpBackBarButtonItem(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.totalRecordTableView.delegate = self
        self.totalRecordTableView.dataSource = self
        guard let intraId = UserInformation.shared.id
            else {
                print("intra id is null")
                return
        }
        self.navigationItem.title = intraId
    }
    
    @objc func didReceiveProjectsNotification(_ noti: Notification) {
        guard let projects: ProjectsAPIResponse = noti.userInfo?["projects"] as? ProjectsAPIResponse
            else {return}
        self.projects = projects.data
        
        
        DispatchQueue.main.async {
            self.totalRecordTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let intraId = UserInformation.shared.id
            else {return}
        
        guard let getProjectAPIurl: URL = URL(string: "http://api.jiduckche.com:5000/api/subject/" + intraId)
            else {return}
        
        let getProjectAPISession: URLSession = URLSession(configuration: .default)
        
        let getProjectAPIDataTask: URLSessionDataTask = getProjectAPISession.dataTask(with: getProjectAPIurl) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data
                else {return}
            do {
                let apiResponse: ProjectsAPIResponse = try JSONDecoder().decode(ProjectsAPIResponse.self, from: data)
                self.projects = apiResponse.data
                DispatchQueue.main.async {
                    self.totalRecordTableView.reloadData()
                }
            } catch (let err) {
                print(err.localizedDescription)
            }
        }

        guard let getPiscineAPIurl: URL = URL(string: "http://api.jiduckche.com:5000/api/piscine/" + intraId)
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
                self.piscineLog = apiResponse.data
                DispatchQueue.main.async {
                    self.totalRecordTableView.reloadData()
                }
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
        
            getProjectAPIDataTask.resume()
            getPiscineAPIDataTask.resume()
    }
    
    @IBAction func touchUpShowMoreEvaluatingLogButton(_ sender: Any) {
           guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailEvaluatingViewController") as? DetailEvaluatingViewController
               else {return}
           self.present(nextViewController, animated: true)
       }
    
    @IBAction func touchUpShowMoreEvaluatedLogButton(_ sender: Any) {

           guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailEvaluatedViewController") as? DetailEvaluatedViewController
               else {return}
           self.present(nextViewController, animated: true)
       }
    
    func showAlertController(reason: String) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "Error", message: reason, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK Action", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: {
            print("alert: \(reason)")
        })
    }
}




extension TotalRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let count = self.projects.count
            print("self.projects.count = \(self.projects.count)")
            return count
//        case 2:
//            let count = self.correctorLogs.count
//            print("self.correctorLogs.count = \(self.correctorLogs.count)")
//            return count
//        case 4:
//            let count = self.correctedLogs.count
//            return count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "통과한 과제"
        case 1: return "1"
        case 2: return "2"
        case 3: return "3"
        case 4: return "4"
        case 5: return "피신 Level/Final Exam"
        default: return "error"
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == 0 {
             return UITableView.automaticDimension
         } else if indexPath.section == 1 {
             return UITableView.automaticDimension
         } else if indexPath.section == 2 {
             return 500
         } else if indexPath.section == 3 {
             return UITableView.automaticDimension
         } else if indexPath.section == 4 {
             return 500
         } else if indexPath.section == 5 {
            return 300
         } else {
             return UITableView.automaticDimension
         }
     }
     
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // api list
        guard let intraId: String = UserInformation.shared.id
            else {return UITableViewCell()}
        switch indexPath.section {
        case 0:
            guard let projectLogCell: ProjectLogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "projectLogCell") as? ProjectLogTableViewCell
                else {return UITableViewCell()}
            // MARK:- 프로젝트 하나하나를 뷰에 올림.
            projectLogCell.projectNameUILabel?.text = projects[indexPath.row]
            // 구분선 없앰.
            projectLogCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            return projectLogCell
        case 1:
            guard let headerOfEvaluatingLogCell: EvaluatingHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerEvaluatingCell") as? EvaluatingHeaderTableViewCell
                else {return UITableViewCell()}
            return headerOfEvaluatingLogCell

        case 3:
            guard let headerOfEvaluatedLogCell: EvaluatedHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerEvaluatedCell") as? EvaluatedHeaderTableViewCell
                else {return UITableViewCell()}
            
            return headerOfEvaluatedLogCell

        case 5:
            guard let piscineLogCell: PiscineLogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "piscineLogCell") as? PiscineLogTableViewCell
                else {return UITableViewCell()}
            
            guard let level: Float = self.piscineLog?.level
                else {
                    print("getting piscineLog.level made error")
                    return UITableViewCell()
            }
            guard let finalScore: Int = self.piscineLog?.exam
                else {
                    print("getting piscineLog.exam made error")
                    return UITableViewCell()
            }
            piscineLogCell.levelUILabel?.text = String(level)
            piscineLogCell.finalScoreUILabel?.text = String(finalScore)
            return piscineLogCell
        default:
            print("default case is called")
            return UITableViewCell()
        }
    }
}
