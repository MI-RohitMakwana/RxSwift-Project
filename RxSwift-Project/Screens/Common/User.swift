//
//  CoreDataModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 03/05/21.
//

import UIKit
import CoreData
import RxDataSources
import RxCoreData

struct User {
    var fullName: String
    var email: String
    var mobile: String
    var id: String
    var date :Date
}

extension User : Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User : IdentifiableType {
    typealias Identity = String
    var identity: Identity { return id }
}

extension User : Persistable {

    typealias T = NSManagedObject

    static var entityName: String { return "User" }
    static var primaryAttributeName: String { return "id" }
    static var shortingAttributeName: String { return "date" }

    init(entity: T) {
        fullName = entity.value(forKey: "fullName") as! String
        email = entity.value(forKey: "email") as! String
        mobile = entity.value(forKey: "mobile") as! String
        id = entity.value(forKey: "id") as! String
        date = entity.value(forKey: "date") as! Date
    }

    func update(_ entity: T) {
        entity.setValue(fullName, forKey: "fullName")
        entity.setValue(email, forKey: "email")
        entity.setValue(mobile, forKey: "mobile")
        entity.setValue(id, forKey: "id")
        entity.setValue(date, forKey: "date")

        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}
