//
//  String+Extension.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 03/05/21.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        return self.validateString(RegexType.email)
    }

    var isValidMobile: Bool {
        return self.validateString(RegexType.mobile)
    }

    var isValidName: Bool {
        return self.validateString(RegexType.name)
    }

    var isEmptyField : Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func validateString(_ pattern: RegexType) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern.rawValue)
        return test.evaluate(with: self)
    }
}

