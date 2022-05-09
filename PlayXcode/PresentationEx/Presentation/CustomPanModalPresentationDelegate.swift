//
//  CustomPanModalPresentationDelegate.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/06.
//

import UIKit

/**
 NSObject를 상속받아야 NSObjectProtocol들을 채택 할 수 있다.
 아래 예제에서 보자면 UIViewControllerTransitioningDelegate도 NSObjectProtocol임.
*/

final class PanModalPresentationDelegate: NSObject {

    var type: PresentationType = .medium
    private var fractionalHeight: CGFloat = 0.9 / 1.0
    
    static var `default`: PanModalPresentationDelegate = {
        return PanModalPresentationDelegate()
    }()

}

extension PanModalPresentationDelegate: UIViewControllerTransitioningDelegate {

    // 모달 화면을 띄울 때 애니메이션 리턴
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: true)
    }

    // 모달 화면을 지울 때 애니메이션 리턴
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: false)
    }

    // 현재의 뷰컨에 모달로 뷰컨을 띄우기 위해 전환을 담당하는 presentation controller 리턴
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPresentationController(presentedViewController: presented, presenting: presenting, type: type, fractionalHeight: fractionalHeight)
        presentationController.delegate = self
        return presentationController
    }
}

extension PanModalPresentationDelegate: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {

    // 아이패드에서 .popover 이나 .custom으로 화면 전환이 이루어지기 위해 필수적임.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
