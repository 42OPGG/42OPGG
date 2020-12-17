//
//  ProjectsModel.swift
//  HellOfLaziness42SeoulHackathonGON
//
//  Created by 최강훈 on 2020/12/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

struct ProjectsAPIResponse: Codable {
    let data: [String]

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CorrectorAPIResponse: Codable {
    let data: [CorrectorLog]
    let success: String
}

struct CorrectorLog: Codable {
    let comment: String
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case comment, feedback
    }
}

struct CorrectedAPIResponse: Codable {
    let data: [CorrectedLog]
    let success: String
}

struct CorrectedLog: Codable {
    let comment: String
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case comment, feedback
    }
}

struct PiscineAPIResponse: Codable {
    let data: PiscineLog
    let success: String
}

struct PiscineLog: Codable {
    let level: Float
    let exam: Int
    
    enum CodingKeys: String, CodingKey {
        case level, exam
    }
}

