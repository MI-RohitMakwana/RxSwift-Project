//
//  GalleryModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import UIKit
import RxDataSources

struct GalleryModel {
    var image: UIImage
    var id: String
    var date :Date
}

extension GalleryModel : Equatable {
    static func == (lhs: GalleryModel, rhs: GalleryModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GalleryModel : IdentifiableType {
    typealias Identity = String
    var identity: Identity { return id }
}
