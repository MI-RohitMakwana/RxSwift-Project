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

    var isValidFullName: Bool {

        guard self.count > 4, self.count < 20 else { return false }
        return self.validateString(RegexType.fullname)
    }
    
    var isOnlyChar: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isLetter || $0.isWhitespace}
    }
    
    var condensed: String {
        return replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }

    func validateLength(size: (min:Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(self.count)
    }

    var isEmptyField : Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func validateString(_ pattern: RegexType) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern.rawValue)
        return test.evaluate(with: self)
    }
}

