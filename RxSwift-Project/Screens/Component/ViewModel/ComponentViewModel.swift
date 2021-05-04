//
//  ComponentViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 02/05/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ComponentViewModel: ViewModelProtocol {

    func transform(_ input: Input) -> Output {
        let sections = input.componentTypes.asObservable()
            .map { componentModels in
                componentModels.map { ComponentModel(type: $0) }
            }
            .compactMap({
                return [ComponentSections(items: $0)]
            })
            .asDriver(onErrorJustReturn: [])
        return Output(sections: sections)
    }
}

extension ComponentViewModel {
    struct Input {
        let componentTypes: Observable<[ComponentType]>
    }

    struct Output {
        let sections: Driver<[ComponentSections]>
    }
}
