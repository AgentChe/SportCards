//
//  ProfileInfoModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Foundation

struct ProfileInfoModel: Decodable {
    let id: String
    let category: String?
    let grade: String?
}
