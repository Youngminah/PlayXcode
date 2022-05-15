//
//  SheetPresentationDelegate.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/06.
//

import UIKit

/**
 NSObject를 상속받아야 NSObjectProtocol들을 채택 할 수 있다.
 아래 예제에서 보자면 UIViewControllerTransitioningDelegate도 NSObjectProtocol임.
*/

final class SheetPresentationDelegate: NSObject {
    
    static var `default`: SheetPresentationDelegate = {
        return SheetPresentationDelegate()
    }()

}

extension SheetPresentationDelegate: UIViewControllerTransitioningDelegate {

    // 모달 화면을 띄울 때 애니메이션 리턴
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetPresentationAnimatedTransitioning(isPresentation: true)
    }

    // 모달 화면을 지울 때 애니메이션 리턴
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetPresentationAnimatedTransitioning(isPresentation: false)
    }

    // 현재의 뷰컨에 모달로 뷰컨을 띄우기 위해 전환을 담당하는 presentation controller 리턴
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.delegate = self
        return presentationController
    }
}

extension SheetPresentationDelegate: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {

    // 아이패드에서 .popover 이나 .custom으로 화면 전환이 이루어지기 위해 필수적임.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
