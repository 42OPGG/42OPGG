//
//  DetailEvaluatedViewController.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class DetailEvaluatedViewController: UIViewController {

    @IBOutlet weak var logTableView: UITableView!
    
    var correctedLogs: [CorrectedLog] = []

    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        // Start animation.
        activityIndicator.stopAnimating()
        return activityIndicator
    }()

    // MARK:- 토스트메시지 출력 함수.
    func showToast(message : String) {
        let width_variable:CGFloat = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y:self.view.frame.size.height-100, width:view.frame.size.width-2*width_variable, height: 35))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options:.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logTableView.delegate = self
        self.logTableView.dataSource = self
        
        self.logTableView.backgroundColor = UIColor(patternImage: UIImage(named: "gon_cover_resize")!)
        
        // add loading code
        self.view.addSubview(self.activityIndicator)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let intraId: String = UserInformation.shared.id
            else {return}
        
        self.activityIndicator.startAnimating()

        guard let getEvaluatedAPIurl: URL = URL(string: "https://opggapi.herokuapp.com/api/corrected/" + intraId + "/15")
            else {return}
        let getEvaluatedAPISession: URLSession = URLSession(configuration: .default)
        let getEvaluatedAPIDataTask: URLSessionDataTask = getEvaluatedAPISession.dataTask(with: getEvaluatedAPIurl) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // unshow loading image
                self.activityIndicator.stopAnimating()
                
                print(error.localizedDescription)
                return
            }
            guard let data = data
                else {return}
            do {
                let apiResponse: CorrectedAPIResponse = try JSONDecoder().decode(CorrectedAPIResponse.self, from: data)
                self.correctedLogs = apiResponse.data
                print("\(self.correctedLogs.count)")
                DispatchQueue.main.async {
                    // unshow loading image
                    self.activityIndicator.stopAnimating()
                    if self.correctedLogs.count == 0 {
                        self.showToast(message: "최근 평가받은 항목이 없습니다.")
                    }
                    self.logTableView.reloadData()
                }
            } catch (let err) {
                // unshow loading image
                self.activityIndicator.stopAnimating()
                print(err.localizedDescription)
            }
        }
        getEvaluatedAPIDataTask.resume()
    }
    
}

extension DetailEvaluatedViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         switch section {
         case 0:
             let topCellHeaderView = UIView()
             topCellHeaderView.backgroundColor = UIColor(white: 1, alpha: 0)
             return topCellHeaderView
         default:
             return UIView()
         }
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         switch section {
         case 0:
             return 7
         default:
             return 0
         }
     }
     
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                 switch section {
         case 0:
             let topCellHeaderView = UIView()
             topCellHeaderView.backgroundColor = UIColor(white: 1, alpha: 0)
             return topCellHeaderView
         default:
             return UIView()
         }
     }
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         switch section {
          case 0:
              return 7
          default:
              return 0
          }
     }
     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let intraId: String = UserInformation.shared.id
            else {return UITableViewCell()}
        let bounds = UIScreen.main.bounds
        let screenWidth = bounds.width - 50
        
        switch indexPath.section {
        case 0:
            guard let cell: FeedbackGottenLogTableViewCell = self.logTableView.dequeueReusableCell(withIdentifier: "feedbackGottenLogCell") as? FeedbackGottenLogTableViewCell
                else {return UITableViewCell()}
            cell.feedbackLogUILabel?.text = "\(intraId) 님께서 평가받은 내역"
            cell.backgroundColor = UIColor(white: 1, alpha: 0.25)
            cell.feedbackLogUILabel.textColor = .white
            return cell
        case 1:
            guard let evaluatedLogCell: EvaluatedLogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "evaluatedLogCell") as? EvaluatedLogTableViewCell
                else {
                    print("can't get EvaluatedLogCell")
                    return UITableViewCell()}
                evaluatedLogCell.commentUILabel?.text = "평가자:  " + self.correctedLogs[indexPath.row].comment
                evaluatedLogCell.commentUILabel.lineBreakMode = .byWordWrapping
                evaluatedLogCell.commentUILabel.preferredMaxLayoutWidth = screenWidth
                evaluatedLogCell.feedbackUILabel.text = "\(intraId):  " + self.correctedLogs[indexPath.row].feedback
                evaluatedLogCell.feedbackUILabel.lineBreakMode = .byWordWrapping
                evaluatedLogCell.feedbackUILabel.preferredMaxLayoutWidth = screenWidth
                evaluatedLogCell.backgroundColor = UIColor(white: 1, alpha: 0.75)

                return evaluatedLogCell
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            let count = self.correctedLogs.count
            return count
        default:
            return 1
        }
    }
}
