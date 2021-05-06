//
//  ComponentModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 30/04/21.
//

import Foundation
import RxDataSources

enum ComponentType {
    case coredata
    case gallery
}

extension ComponentType {
    var title: String {
        switch self {
        case .coredata:
            return "Core Data"
        case .gallery:
            return "Gallery"
        }
    }
}

struct ComponentSections {
    var items: [Item]
}

extension ComponentSections: SectionModelType {
    typealias Item = ComponentModel
    init(original: ComponentSections, items: [Item]) {
        self = original
        self.items = items
    }
}

struct ComponentModel {
    var type: ComponentType
}
