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

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    func configureTableView() {
        tableView.isEditing = true
        
        

        let animatedDataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Event>>(configureCell: { dateSource, tableView, indexPath, event in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "\(event.date)"
            return cell
        })
        
        managedObjectContext.rx.entities(Event.self, sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
            .map { events in
                [AnimatableSectionModel(model: "Section 1", items: events)]
            }
            .bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)
 
        self.tableView.rx.itemDeleted.map { [unowned self] ip -> Event in
            return try self.tableView.rx.model(at: ip)
            }
            .subscribe(onNext: { [unowned self] (event) in
                do {
                    try self.managedObjectContext.rx.delete(event)
                } catch {
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        animatedDataSource.canEditRowAtIndexPath = { _,_  in
            return true
        }
        animatedDataSource.canMoveRowAtIndexPath = { _,_  in
            return true
        }
    }
}

