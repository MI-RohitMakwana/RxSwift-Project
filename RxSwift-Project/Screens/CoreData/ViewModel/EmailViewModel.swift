//
//  EmailViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import Foundation
import RxCocoa

final class EmailViewModel: ValidationViewModel {

    var errorMessage: String = AlertMessage.inValidEmail

    // Observables
    var value: BehaviorRelay<String> = BehaviorRelay(value: "")

    // Validation methods
    var isValidField: Bool {
        return value.value.isValidEmail
    }

    // De-init
    deinit {
        print("\(self) dealloc")
    }
}
