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
}

extension ComponentType {
    var title: String {
        return "Core Data"
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
