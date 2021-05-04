//
//  AddUserViewController.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 01/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData
import RxDataSources
import RxCoreData

class AddUserViewController: UIViewController, Storyboarable {

    //MARK:- IBOutlets -
    @IBOutlet private weak var fullnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var addUserButton: UIButton!

    //MARK:- Variables -
    private let disposeBag = DisposeBag()
    private var viewModel = AddUserViewModel()
    private var editedUser: User?
    var id: String?

    //MARK:- View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultData(id: self.id)
    }
}

//MARK:- Helper Methods
extension AddUserViewController {

    func setDefaultData(id: String?) {
        guard let id = id else {
            createBinding()
            return
        }
        self.id = id
        CoreDataModel.shared.managedObjectContext
            .rx
            .entities(User.self, predicate: NSPredicate(format: "%K == %@", "id", id), sortDescriptors: nil)
            .subscribe({ users in
                if let user = users.element?.first {
                    self.editedUser = user
                    self.fullnameTextField.text = user.fullName
                    self.emailTextField.text = user.email
                    self.mobileTextField.text = user.mobile
                    self.createBinding()
                }
            })
            .disposed(by: disposeBag)
    }

    private func createBinding() {

        let input = AddUserViewModel.Input(fullname: fullnameTextField.rx.text.orEmpty.distinctUntilChanged(),
                                           email: emailTextField.rx.text.orEmpty.distinctUntilChanged(),
                                           mobile: mobileTextField.rx.text.orEmpty.distinctUntilChanged(),
                                           addUser: addUserButton.rx.tap.asObservable())
        let output = viewModel.transform(input)

        output.addUserEnabled.drive(onNext: { [weak self] in
            self?.addUserButton.isEnabled = $0
            self?.addUserButton.alpha = $0 ? 1: 0.2
        }).disposed(by: disposeBag)

        addUserButton.rx.tap
            .map { [unowned  self] _ -> User in
                return User(fullName: self.fullnameTextField.text!,
                            email: self.emailTextField.text!,
                            mobile: self.mobileTextField.text!,
                            id: id ?? UUID().uuidString,
                            date: Date())
            }.subscribe(onNext: { [weak self] (user) in
                _ = try? CoreDataModel.shared.managedObjectContext.rx.update(user)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
