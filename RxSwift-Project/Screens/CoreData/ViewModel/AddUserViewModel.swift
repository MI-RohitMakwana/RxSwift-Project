//
//  AddUserViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 02/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import RxCoreData

final class AddUserViewModel {

    // Fields that bind to our view's
    let isSuccess: PublishRelay<Bool> = PublishRelay()
    let isLoading: PublishRelay<Bool> = PublishRelay()
    let errorMessage: PublishRelay<String?> = PublishRelay()

    private let disposeBag = DisposeBag()

    private let fullNameViewModel = FullNameViewModel()
    private let emailViewModel = EmailViewModel()
    private let mobileViewModel = MobileViewModel()

    func transform(_ input: Input) -> Output {

        let fields = Observable.combineLatest(input.fullname, input.email, input.mobile)
        let canAddUser = fields.asObservable()
            .map({ (fullname, email, mobile) in
                return !fullname.isEmptyField &&
                    !email.isEmptyField &&
                    !mobile.isEmptyField
            })
            .startWith(false)
            .asDriver(onErrorJustReturn: false)

        input.fullname.bind(to: fullNameViewModel.value)
            .disposed(by: disposeBag)

        input.email.bind(to: emailViewModel.value)
            .disposed(by: disposeBag)

        input.mobile.bind(to: mobileViewModel.value)
            .disposed(by: disposeBag)

        return Output(addUserEnabled: canAddUser)
    }

    var isValidateCredential: Bool {
        if self.fullNameViewModel.isValidField  {
           if self.emailViewModel.isValidField  {
               if self.mobileViewModel.isValidField  {
                    return true
                } else {
                    errorMessage.accept(mobileViewModel.errorMessage)
                }
            } else {
                errorMessage.accept(emailViewModel.errorMessage)
            }
        } else {
            errorMessage.accept(fullNameViewModel.errorMessage)
        }
        return false
    }
}

extension AddUserViewModel {
    struct Input {
        let fullname: Observable<String>
        let email: Observable<String>
        let mobile: Observable<String>
        let addUser: Observable<Void>
    }

    struct Output {
        let addUserEnabled: Driver<Bool>
    }
}
