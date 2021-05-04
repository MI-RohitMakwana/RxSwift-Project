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

    private let disposeBag = DisposeBag()

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

        //        let _ = fields.asObservable()
//            .map({ (fullname, email, mobile) -> String in
//                if fullname.isValidName &&
//                    email.isValidEmail &&
//                    mobile.isValidMobile {
//                    return ""
//                }
//                else {
//                    self.error.v
//                }
//            })
//            .subscribe()
//            .disposed(by: bag)

//        let result = input.addUser.asObservable()
//            .withLatestFrom(fields)
//            .map({ (fullname, email, mobile) -> (String, String, String, Bool) in
//                if fullname.isValidName &&
//                    email.isValidEmail &&
//                    mobile.isValidMobile {
//                   return (fullname, email, mobile, true)
//                }
//                else {
//                    self.error.onNext("Error")
//                    return ("", "", "", false)
//                }
//            })

//            .filter({ (fullname, email, mobile, error) in
//                error == true
//            })

        return Output(addUserEnabled: canAddUser)
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
