//
//  CoreDataListViewController.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 30/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData
import RxDataSources
import RxCoreData

class CoreDataListViewController: UIViewController, Storyboarable {

    //MARK:- IBOutlets -
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
    }

    //MARK:- Variables -
    private let cellIdentifier = "Cell"
    private let disposeBag = DisposeBag()
    private var viewModel = ComponentViewModel()
    private var addButton : UIBarButtonItem!

    //MARK:- View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

//MARK:- Helper Methods
private extension CoreDataListViewController {

    func initialize() {
        setupUI()
        configureTableView()
    }

    private func setupUI()  {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonAction() {
        navigateAddUserViewController(nil)
    }

    func navigateAddUserViewController(_ id: String?) {
        let view = AddUserViewController.instantiateFrom(StoryBoard: .coraData)
        view.id = id
        self.navigationController?.pushViewController(view, animated: true)
    }
}

//MARK:- Configure TableView
private extension CoreDataListViewController {

    func configureTableView() {
        let animatedDataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, User>>(configureCell: { dateSource, tableView, indexPath, user in
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: self.cellIdentifier)
            cell.selectionStyle = .none
            cell.textLabel?.text = "\(user.fullName)"
            cell.detailTextLabel?.text = "\(user.email) \(user.mobile)"
            return cell
        })

        CoreDataModel.shared.managedObjectContext
            .rx
            .entities(User.self, sortDescriptors: [NSSortDescriptor(key: User.shortingAttributeName, ascending: false)])
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)
 
        tableView.rx.itemDeleted.map { [unowned self] ip -> User in
            return try self.tableView.rx.model(at: ip)
        }
        .subscribe(onNext: { (event) in
            do {
                try CoreDataModel.shared.managedObjectContext.rx.delete(event)
            } catch {
                print(error)
            }
        })
        .disposed(by: disposeBag)

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(User.self))
            .bind { [unowned self] indexPath, user in
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.navigateAddUserViewController(user.id)
            }
            .disposed(by: disposeBag)

        animatedDataSource.canEditRowAtIndexPath = { _,_  in
            return true
        }
    }
}
