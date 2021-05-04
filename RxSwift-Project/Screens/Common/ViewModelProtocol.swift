//
//  Common.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 02/05/21.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}

