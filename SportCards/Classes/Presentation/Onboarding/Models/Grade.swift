//
//  Grade.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation

enum Grade: String, CaseIterable, Decodable {
    case all
    case raw
    case psa
    case bgs
    case sgc
    case csg
}

extension Grade {
    var title: String {
        switch self {
        case .all:
            "Grade.ALL".localized
        case .raw:
            "Grade.RAW.Title".localized
        case .psa:
            "Grade.PSA.Title".localized
        case .bgs:
            "Grade.BGS.Title".localized
        case .sgc:
            "Grade.SGC.Title".localized
        case .csg:
            "Grade.CSG.Title".localized
        }
    }
    
    var description: String? {
        switch self {
        case .all:
            nil
        case .raw:
            "Grade.RAW.Description".localized
        case .psa:
            "Grade.PSA.Description".localized
        case .bgs:
            "Grade.BGS.Description".localized
        case .sgc:
            "Grade.SGC.Description".localized
        case .csg:
            "Grade.CSG.Description".localized
        }
    }
    
    var shortName: String? {
        switch self {
        case .all:
            nil
        case .raw:
            "Grade.RAW.Short".localized
        case .psa:
            "Grade.PSA.Short".localized
        case .bgs:
            "Grade.PSA.Short".localized
        case .sgc:
            "Grade.SGC.Short".localized
        case .csg:
            "Grade.CSG.Short".localized
        }
    }
}
