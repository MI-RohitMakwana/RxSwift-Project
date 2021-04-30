//
//  Storyboarable.swift
//  RxSwift-Project
//
//  Created by mind-0023 on 30/04/21.
//

import UIKit

enum StoryBoardType: String {
    case main = "Main"
}

protocol Storyboarable {
    static func instantiateFrom(StoryBoard storyBoard: StoryBoardType) -> Self
}

extension Storyboarable where Self: UIViewController {

    static func instantiateFrom(StoryBoard storyBoard: StoryBoardType) -> Self {
        let fullname = NSStringFromClass(self)
        let className = fullname.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: className)
    }
}
