//
//  ComponentListViewController.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 30/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ComponentListViewController: UIViewController {

    //MARK:- IBOutlets -
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }

    //MARK:- Variables -
    let disposeBag = DisposeBag()
    private var items : [ComponentType] = [.coredata]

    //MARK:- LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    //MARK:- Helper Methods-
    private
    func configureTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<ComponentSections>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "\(indexPath.row + 1) : \(item.type.title)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
                return cell
            }
        )

        let sections = [ComponentSections(items: items.map ({ ComponentModel(type: $0) }))]
        Observable.just(sections)
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)

        tableView.rx.modelSelected(ComponentModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] component in
                self.navigate(component)
//                var vc = RecipeViewController.initFromNib()
//                vc.bind(to: RecipeViewModel(withRecipe: recipe))
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func navigate(_ model: ComponentModel) {
        switch model.type {
        case .coredata:
            let view = CoreDataListViewController.instantiateFrom(StoryBoard: .main)
            self.navigationController?.pushViewController(view, animated: true)
            break
        }
    }
}

