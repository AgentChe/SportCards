//
//  GradeService.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Foundation

struct GradeService: Hashable {
    let alias: String
    let name: String
    let values: Set<String>
}

extension GradeService: Codable {
    enum CodingKeys: String, CodingKey {
        case alias
        case name
        case values
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alias = try container.decode(String.self, forKey: .alias)
        self.name = try container.decode(String.self, forKey: .name)
        let values = try? container.decode([String].self, forKey: .values)
        
        self.values = values.map { Set($0) } ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alias, forKey: .alias)
        try container.encode(name, forKey: .name)
        try container.encode(Array(values), forKey: .values)
    }
}

struct GradesResponse: Codable {
    let grade: [String: String]
    let service: [GradeService]
}
