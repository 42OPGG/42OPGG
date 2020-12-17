//
//  DetailEvaluatingViewController.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class DetailEvaluatingViewController: UIViewController {

    @IBOutlet weak var logTableView: UITableView!

    var correctorLogs: [CorrectorLog] = []

    @IBAction func touchUpBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logTableView.delegate = self
        self.logTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let intraId = UserInformation.shared.id
            else {return}
        
        guard let getEvaluatingAPIurl: URL = URL(string: "http://api.jiduckche.com:5000/api/corrector/" + intraId + "/15")
            else {return}
    
            let getEvaluatingAPISession: URLSession = URLSession(configuration: .default)
            let getEvaluatingAPIDataTask: URLSessionDataTask = getEvaluatingAPISession.dataTask(with: getEvaluatingAPIurl) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data
                    else {return}
                do {
                    let apiResponse: CorrectorAPIResponse = try
                        JSONDecoder().decode(CorrectorAPIResponse.self, from: data)
                    self.correctorLogs = apiResponse.data
                    DispatchQueue.main.async {
                        self.logTableView.reloadData()
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
            }
        getEvaluatingAPIDataTask.resume()
    }

}

extension DetailEvaluatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let intraId: String = UserInformation.shared.id
            else {return UITableViewCell()}
        let bounds = UIScreen.main.bounds
        let screenWidth = bounds.width - 50
        
        switch indexPath.section {
        case 0:
            guard let cell: FeedbackGivenLogTableViewCell = self.logTableView.dequeueReusableCell(withIdentifier: "feedbackGivenLogCell") as? FeedbackGivenLogTableViewCell
                else {
                    print("gettingFeedbackLogTableViewCell made error")
                return UITableViewCell()
            }
            // 여러 줄이 나오도록 설정.
            cell.feedbackLogUILabel.numberOfLines = 0
            // 평가 코멘트 하나하나의 MaxWidth를 설정.
            let bounds = UIScreen.main.bounds
            let width = bounds.width
            cell.feedbackLogUILabel.preferredMaxLayoutWidth = width - 50
            return cell
        case 1:
            guard let evaluatingLogCell: EvaluatingLogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "evaluatingLogCell") as? EvaluatingLogTableViewCell
            else {return UITableViewCell()}
            evaluatingLogCell.commentUILabel?.text = "\(intraId): " + self.correctorLogs[indexPath.row].comment
            evaluatingLogCell.commentUILabel.lineBreakMode = .byWordWrapping
            evaluatingLogCell.commentUILabel.preferredMaxLayoutWidth = screenWidth
            evaluatingLogCell.feedbackUILabel.text = "reply: " + self.correctorLogs[indexPath.row].feedback
            evaluatingLogCell.feedbackUILabel.lineBreakMode = .byWordWrapping
            evaluatingLogCell.feedbackUILabel.preferredMaxLayoutWidth = screenWidth
                return evaluatingLogCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 2
     }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            let count = self.correctorLogs.count
            print("FeedbackLog count: \(count)")
            return count
        default:
            return 1
        }
    }
}

