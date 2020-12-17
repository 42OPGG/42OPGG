//
//  RequestProjects.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

let DidReceiveProjectsNotification: Notification.Name
    = Notification.Name("DidReceiveProjects")

func requestProjects(userName: String) {
    guard let apiURL: URL = URL(string: "http://api.jiduckche.com:5000/api/subject/" + userName)
        else {return}
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print (error.localizedDescription)
            return
        }
        guard let data = data
            else { return }
        
        do {
            let apiResponse: ProjectsAPIResponse = try JSONDecoder().decode(ProjectsAPIResponse.self, from: data)
            NotificationCenter.default.post(name: DidReceiveProjectsNotification, object: nil, userInfo: ["projects": apiResponse.data])
            
            UserInformation.shared.projects = apiResponse.data
            
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}
