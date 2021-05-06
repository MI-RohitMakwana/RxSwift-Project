//
//  MobileViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import Foundation
import RxCocoa

final class MobileViewModel: ValidationViewModel {

    var errorMessage: String = AlertMessage.inValidmobile

    // Observables
    var value: BehaviorRelay<String> = BehaviorRelay(value: "")

    // Validation methods
    var isValidField: Bool {
        return value.value.isValidMobile
    }

    // De-init
    deinit {
        print("\(self) dealloc")
    }
}
