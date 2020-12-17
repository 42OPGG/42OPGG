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
        
        self.totalRecordTableView.backgroundColor = UIColor(patternImage: UIImage(named: "gon_cover_resize")!)
        
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
        
        guard let getProjectAPIurl: URL = URL(string: "http://api.jiduckche.com/api/subject/" + intraId)
            else {return}
        
        let getProjectAPISession: URLSession = URLSession(configuration: .default)
        
        let getProjectAPIDataTask: URLSessionDataTask = getProjectAPISession.dataTask(with: getProjectAPIurl) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlertController(reason: "can't get api")
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

        guard let getPiscineAPIurl: URL = URL(string: "http://api.jiduckche.com/api/piscine/" + intraId)
            else {return}
        let getPiscineAPISession: URLSession = URLSession(configuration: .default)
        let getPiscineAPIDataTask: URLSessionDataTask = getPiscineAPISession.dataTask(with: getPiscineAPIurl) {
            (data: Data?, reponse: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlertController(reason: error.localizedDescription)
                return
            }
            guard let data = data
                else {return}
            do {
                let apiResponse: PiscineAPIResponse = try JSONDecoder().decode(PiscineAPIResponse.self, from: data)
                self.piscineLog = apiResponse.data
                if apiResponse.success == "false" {
                    self.showAlertController(reason: "해당 id로 조회할 수 있는 사람이 없습니다.")
                }
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

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        switch section {
//        case 0: return "통과한 과제 목록"
//        case 3: return "Piscine Level / Final Score"
//        default: return ""
//        }
//    }
    
    // MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let halfWidth = UIScreen.main.bounds.width / 2
        
        switch section {
        case 0:
            let projectListHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            projectListHeaderView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            
            let label = UILabel(frame: CGRect(x: halfWidth, y: 0, width: 150, height: 50))
            label.text = "통과한 과제 목록"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            label.textAlignment = .center
            label.center.x = self.view.center.x
            projectListHeaderView.addSubview(label)
            
            return projectListHeaderView
        case 1:
            let evaluatingLogHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
             evaluatingLogHeaderView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            let label = UILabel(frame: CGRect(x: halfWidth, y: 0, width: 150, height: 50))
            label.text = "평가한 내역"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            label.textAlignment = .center
            label.center.x = self.view.center.x
            evaluatingLogHeaderView.addSubview(label)
            
            return evaluatingLogHeaderView
        case 2:
            let evaluatedLogHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
             evaluatedLogHeaderView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            let label = UILabel(frame: CGRect(x: halfWidth, y: 0, width: 150, height: 50))
            label.text = "평가받은 내역"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            label.textAlignment = .center
            label.center.x = self.view.center.x
            evaluatedLogHeaderView.addSubview(label)
            
            return evaluatedLogHeaderView
        case 3:
            let piscineLogHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
             piscineLogHeaderView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            let label = UILabel(frame: CGRect(x: halfWidth, y: 0, width: 150, height: 50))
            label.text = "Piscine"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            label.textAlignment = .center
            label.center.x = self.view.center.x
            piscineLogHeaderView.addSubview(label)
            
            return piscineLogHeaderView
        default:
            return UIView()
        }
    }

    // Header Height 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        case 1:
            return 50
        case 2:
            return 50
        case 3:
            return 50
        default:
            return 0
        }
    }
    

    
    // MARK: Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 3 {
            let eachFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            eachFooterView.backgroundColor = UIColor(white: 1, alpha: 0)
            return eachFooterView
        } else {
            let eachFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
             eachFooterView.backgroundColor = UIColor(white: 1, alpha: 0)
             return eachFooterView
        }
       
    }
    
    
    // MARK: section Height 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == 0 {
             return UITableView.automaticDimension
         } else if indexPath.section == 1 {
             return 50
         } else if indexPath.section == 2 {
            return 50
         } else if indexPath.section == 3 {
             return 150
         } else {
             return UITableView.automaticDimension
         }
     }
     
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            // 배경 투명도
            projectLogCell.backgroundColor = UIColor(white: 1, alpha: 0.75)
            return projectLogCell
        case 1:
            guard let headerOfEvaluatingLogCell: EvaluatingHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerEvaluatingCell") as? EvaluatingHeaderTableViewCell
                else {return UITableViewCell()}
            headerOfEvaluatingLogCell.backgroundColor = UIColor(white: 1, alpha: 0.75)
            return headerOfEvaluatingLogCell

        case 2:
            guard let headerOfEvaluatedLogCell: EvaluatedHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerEvaluatedCell") as? EvaluatedHeaderTableViewCell
                else {return UITableViewCell()}
            headerOfEvaluatedLogCell.backgroundColor = UIColor(white: 1, alpha: 0.75)

            return headerOfEvaluatedLogCell

        case 3:
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
            piscineLogCell.finalScoreUILabel?.text = String(finalScore) + " / 100"
            
            // cell 배경 투명하게
            piscineLogCell.backgroundColor = UIColor(white: 1, alpha: 0.75)
            piscineLogCell.levelUILabel.backgroundColor = .yellow
            
            return piscineLogCell
        default:
            print("default case is called")
            return UITableViewCell()
        }
    }
}
