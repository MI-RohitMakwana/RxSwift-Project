//
//  GalleryViewController.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class GalleryViewController: UIViewController, Storyboarable {

    @IBOutlet private weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var addButton : UIBarButtonItem!
    private var viewModel : GalleryViewModel!
    private let reuseIdentifier = "GalleryCollectionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

//MARK:- Helper Methods
private extension GalleryViewController {

    func initialize() {
        viewModel = GalleryViewModel(self)
        setupUI()
        configureCollectionView()
    }
    
    private func setupUI()  {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        self.navigationItem.rightBarButtonItem = addButton

        self.view.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (self.collectionView.frame.width/2)-15, height: (self.collectionView.frame.width/2)-15)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @objc func addButtonAction() {
        viewModel.selectPhoto()
    }
}


//MARK:- Configure CollectionView
private extension GalleryViewController {

    func configureCollectionView() {

        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let animatedDataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, GalleryModel>>(configureCell: { dateSource, collectionView, indexPath, imageObjc in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! GalleryCollectionCell
            cell.backgroundColor = .red
            cell.imageView.image = imageObjc.image
            return cell
        })

        viewModel.images.asObservable()
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)

        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(User.self))
            .bind { [unowned self] indexPath, user in
                // do something which tap on cell
            }
            .disposed(by: disposeBag)
    }
}


extension GalleryViewController: RxMediaPickerDelegate {

    func present(picker: UIImagePickerController) {
        print("Will present picker")
        present(picker, animated: true, completion: nil)
    }

    func dismiss(picker: UIImagePickerController) {
        print("Will dismiss picker")
        dismiss(animated: true, completion: nil)
    }
}

