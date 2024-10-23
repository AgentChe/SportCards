//
//  CardUploadResponse.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import Foundation

struct CardUploadResponse {
    let id: String
    let imageURL: URL?
    let title: String
    let subtitle: String?
    let grades: [String]
}

extension CardUploadResponse {
    init?(response: Data?) {
        guard
            let response,
            let json = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String: Any],
            let body = json["body"] as? [String: Any],
            let id = body["id"] as? String,
            let grades = body["grades"] as? [String]
        else { return nil }
        
        self.id = id
        self.imageURL = (body["image"] as? String).flatMap { URL(string: $0) }
        self.title = body["title"] as? String ?? ""
        self.subtitle = body["subtitle"] as? String ?? ""
        self.grades = grades
    }
}
