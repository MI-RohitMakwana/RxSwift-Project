//
//  GalleryViewModel.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 05/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class GalleryViewModel {

    private var picker: RxMediaPicker!

    var images: BehaviorRelay<[GalleryModel]> = BehaviorRelay(value: [GalleryModel(image: UIImage.init(named: "image1")!, id: UUID().uuidString, date: Date()), GalleryModel(image: UIImage.init(named: "image2")!, id: UUID().uuidString, date: Date())])
    let disposeBag = DisposeBag()
    
    init(_ galleryVC: GalleryViewController) {
        self.picker = RxMediaPicker(delegate: galleryVC)
    }

    func selectPhoto() {
        picker.selectImage(editable: true)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (image, editedImage) in
                var newValue = self.images.value
                newValue.append(GalleryModel(image: image, id: UUID().uuidString, date: Date()))
                self.images.accept(newValue)
            }, onError: { error in
                print("Picker photo error: \(error)")
            }, onCompleted: {
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
}
