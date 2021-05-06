//
//  FullNameViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import Foundation
import RxCocoa

final class FullNameViewModel: ValidationViewModel {

    var errorMessage: String = AlertMessage.inValidFullname

    // Observables
    var value: BehaviorRelay<String> = BehaviorRelay(value: "")

    // Validation methods
    var isValidField: Bool {
        return value.value.isValidFullName
    }

    // De-init
    deinit {
        print("\(self) dealloc")
    }
}
