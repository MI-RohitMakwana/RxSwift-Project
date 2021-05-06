//
//  Common.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 02/05/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}

protocol ValidationViewModel {

    // Variable
    var errorMessage: String { get }

    // Observables
    var value: BehaviorRelay<String> { get set }

    // Validation methods
    var isValidField: Bool { get }
}
