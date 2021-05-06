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
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }

    //MARK:- Variables -
    private let disposeBag = DisposeBag()
    private var viewModel = ComponentViewModel()
    private let items : Observable<[ComponentType]> = Observable.from(optional: [.coredata, .gallery])

    //MARK:- View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    //MARK:- Helper Methods-
    private
    func configureTableView() {

        let input = ComponentViewModel.Input(componentTypes: items)
        let output = viewModel.transform(input)

        let dataSource = RxTableViewSectionedReloadDataSource<ComponentSections>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "\(indexPath.row + 1) : \(item.type.title)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
                return cell
            }
        )

        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ComponentModel.self))
            .bind { [unowned self] indexPath, model in
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.navigate(model)
            }
            .disposed(by: disposeBag)

        output.sections.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func navigate(_ model: ComponentModel) {
        switch model.type {
        case .coredata:
            let view = CoreDataListViewController.instantiateFrom(StoryBoard: .coraData)
            self.navigationController?.pushViewController(view, animated: true)
            break
        case .gallery:
            let view = GalleryViewController.instantiateFrom(StoryBoard: .gallery)
            self.navigationController?.pushViewController(view, animated: true)
            break
        }
    }
}
