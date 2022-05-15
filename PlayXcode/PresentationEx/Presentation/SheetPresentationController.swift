//
//  SheetPresentationController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

enum PresentationType {
    case none(CGFloat)
    case max
    case high
    case medium
    case low
    case min
    
    var positionY: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        switch self {
        case .none(let fractionY):
            return screenHeight*(fractionY)
        case .max:
            return screenHeight*(0.1/1.0)
        case .high:
            return screenHeight*(0.25/1.0)
        case .medium:
            return screenHeight*(0.5/1.0)
        case .low:
            return screenHeight*(0.75/1.0)
        case .min:
            return screenHeight*(0.85/1.0)
        }
    }
}

/**
 ContainerView : UITransitionView
 Presented VIew :
 */

final class SheetPresentationController: UIPresentationController {
    
    enum PresentationState {
        case shortForm
        case longForm
    }
    
    struct Constants {
        static let indicatorYOffset = CGFloat(8.0)
        static let snapMovementSensitivity = CGFloat(0.7)
    }
    
    // MARK: - Properties
    private var dimmingView: DimmingView!
    
    private var isPresentedViewAnimating = false
    private var extendsSheetScrolling = true
    private var anchorModalToLongForm = true
    
    private var scrollViewYOffset: CGFloat = 0.0
    private var scrollObserver: NSKeyValueObservation?
    
    private var shortFormYPosition: CGFloat = 0
    private var longFormYPosition: CGFloat = 0
    
    private var anchoredYPosition: CGFloat {
        let defaultTopOffset = presentable?.topOffset ?? 0
        return anchorModalToLongForm ? longFormYPosition : defaultTopOffset
    }
    
    // SheetPresentationController의 Configuration 객체
    private var presentable: SheetPresentable? {
        return presentedViewController as? SheetPresentable
    }
    
    override var presentedView: UIView {
        return sheetContainerView
    }
    
    // presented view를 래핑하는 뷰로, 원하는 대로 뷰의 모양 등등을 조정할 수 있게 함
    private lazy var sheetContainerView: SheetContainerView = {
        let frame = containerView?.frame ?? .zero
        return SheetContainerView(
            presentedView: presentedViewController.view,
            frame: frame
        )
    }()
    
    deinit {
        scrollObserver?.invalidate()
    }
    
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    // MARK: - Lifecycle

    // 띄우는 화면 전환 애니메이션이 시작하려 할 때 실행되는 함수
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        guard let dimmingView = dimmingView else { return }
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        configureScrollViewInsets()

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        })
    }
    
    // 띄우는 화면 전환 애니메이션이 끝났을 때 실행되는 함수
    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if completed { return }
        dimmingView.removeFromSuperview()
    }
    
    // 컨테이너뷰의 뷰들이 레이아웃을 시작하려할 때 실행되는 함수. containerViewDidLayoutSubviews도 있음.
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        configureViewLayout()
    }
    
    // 사라지는 화면 전환 애니메이션이 시작되려할 때 실행되는 함수
    override func dismissalTransitionWillBegin() {
        presentable?.sheetModalWillDismiss()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    // 사라지는 화면 전환 애니메이션이 끝났을 때 실행되는 함수
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed { return }
        presentable?.sheetModalDidDismiss()
    }
    
    // 컨테이너의 루트 뷰의 크기가 변경되려고 하면 실행되는 함수.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition 실행!! ", viewWillTransition)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
//            guard
//                let self = self,
//                let presentable = self.presentable
//                else { return }

            self.adjustPresentedViewFrame()
//            if presentable.shouldRoundTopCorners {
//                self.addRoundedCorners(to: self.presentedView)
//            }
        })
    }
}

// MARK: - Common Layout Update Methods

extension SheetPresentationController {
    
    // PresentationState 값에 따른 전환
    func transition(to state: PresentationState) {
        guard presentable?.shouldTransition(to: state) == true else { return }
        presentable?.willTransition(to: state)

        switch state {
        case .shortForm:
            snap(toYPosition: shortFormYPosition)
        case .longForm:
            snap(toYPosition: longFormYPosition)
        }
    }

    /**
     스크롤 관련 작업에서, 콘텐츠의 높이가 변경되거나, 행의 삽입 삭제가 이루어지면 모달이 점프 할 수 있음.
     이러한 현상을 막기위해, 이 함수를 불러 스크롤 observation을 일시적으로 사용불가능하게 만들고, 스크롤뷰의 업데이트를 진행함.
     */
    func performUpdates(_ updates: () -> Void) {
        
        guard let scrollView = presentable?.sheetScrollView else { return }
        scrollObserver?.invalidate()
        scrollObserver = nil
        updates()
        trackScrolling(scrollView)
        observe(scrollView: scrollView)
    }
    
    /**
     SheetModalPresentable에 값을 가지고
     SheetPresentationControllerdml 레이아웃을 업데이트 하기 위한 함수.
     */
    func setNeedsLayoutUpdate() {
        configureViewLayout()
        adjustPresentedViewFrame()
        observe(scrollView: presentable?.sheetScrollView)
        configureScrollViewInsets()
    }
}

// MARK: - Presented View Layout Configuration

extension SheetPresentationController {
    
    // presented view가 고정되어있는지 여부를 나타내는 Boolean 값
    var isPresentedViewAnchored: Bool {
        if !isPresentedViewAnimating
            && extendsSheetScrolling
            && presentedView.frame.minY.rounded() <= anchoredYPosition.rounded() {
            return true
        }
        return false
    }
    
    private func setupDimmingView() {
        dimmingView = DimmingView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.didTap = { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true)
        }
    }
    
    // 컨테이너 뷰에 presented view를 추가하고, 팬 제스쳐 달고, Layout 업데이트
    func layoutPresentedView(in containerView: UIView) {
        containerView.addSubview(presentedView)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(didSheetScrollOnPresentedView(recognizer:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delaysTouchesBegan = false
        panGestureRecognizer.delaysTouchesEnded = false
        panGestureRecognizer.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer)

        setNeedsLayoutUpdate()
        adjustSheetContainerBackgroundColor()
    }
    
    // 화면의 맨 아래에 위치하도록 presentView의 높이를 줄이는 함수.
    func adjustPresentedViewFrame() {
        presentedView.isUserInteractionEnabled = true
        guard let frame = containerView?.frame else { return }

        let adjustedSize = CGSize(width: frame.size.width, height: frame.size.height - anchoredYPosition)
        let sheetFrame = sheetContainerView.frame
        sheetContainerView.frame.size = frame.size
        if ![shortFormYPosition, longFormYPosition].contains(sheetFrame.origin.y) {
            let yPosition = sheetFrame.origin.y - sheetFrame.height + frame.height
            presentedView.frame.origin.y = max(yPosition, anchoredYPosition)
        }
        sheetContainerView.frame.origin.x = frame.origin.x
        presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }
    
    /**
     Long Form 형태로 띄워지면서, 바닥에 바운스가 일어날 때,
     배경색을 줌으로써 바닥 부분에 갭이 보이지 않도록
     panContainerView의 배경색을 띄워질 뷰의 배경색과 맞춰줌.
     */
    func adjustSheetContainerBackgroundColor() {
        sheetContainerView.backgroundColor = presentedViewController.view.backgroundColor
            ?? presentable?.sheetScrollView?.backgroundColor
    }
    
    
    // Dimming View를 뷰 계층에 추가하고, 오토레이아웃 잡아주는 메소드.
    func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubview(dimmingView)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    // 레이아웃 고정 포인트 프로퍼티들에 SheetPresentable을 기반으로 값을 계산하고 저장하는 메소드.
    func configureViewLayout() {
        guard let layoutPresentable = presentedViewController as? SheetPresentable.LayoutType else { return }
        shortFormYPosition = layoutPresentable.shortFormYPos
        longFormYPosition = layoutPresentable.longFormYPos
        anchorModalToLongForm = layoutPresentable.anchorModalToLongForm
        extendsSheetScrolling = layoutPresentable.allowsExtendedSheetScrolling
        presentedView.layer.cornerRadius = layoutPresentable.cornerRadius
        containerView?.isUserInteractionEnabled = layoutPresentable.isUserInteractionEnabled
    }
    
    // 스크롤 뷰의 인셋 값을 주는 메소드.
    func configureScrollViewInsets() {
        guard let scrollView = presentable?.sheetScrollView, !scrollView.isScrolling
            else { return }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = presentable?.scrollIndicatorInsets ?? .zero
        scrollView.contentInset.bottom = presentingViewController.view.safeAreaInsets.bottom
        scrollView.contentInsetAdjustmentBehavior = .never // 스크롤뷰의 인셋 조절해 주지 않음. adjustContentInset값은 .zero임.
    }
}
 
// MARK: - Sheet Gesture Event Handler

extension SheetPresentationController {
    
    @objc func didSheetScrollOnPresentedView(recognizer: UIPanGestureRecognizer) {
        
        guard shouldRespond(to: recognizer), let containerView = containerView else {
            recognizer.setTranslation(.zero, in: recognizer.view)
            return
        }
        
        switch recognizer.state {
        case .began, .changed:
            respond(to: recognizer)
            
            if presentedView.frame.origin.y == anchoredYPosition && extendsSheetScrolling {
                presentable?.willTransition(to: .longForm)
            }
        
        default:
            let velocity = recognizer.velocity(in: presentedView)

            if isVelocityWithinSensitivityRange(velocity.y) {

                if velocity.y < 0 {
                    transition(to: .longForm)

                } else if (nearest(to: presentedView.frame.minY, inValues: [longFormYPosition, containerView.bounds.height]) == longFormYPosition
                    && presentedView.frame.minY < shortFormYPosition) || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }

            } else {

                let position = nearest(to: presentedView.frame.minY, inValues: [containerView.bounds.height, shortFormYPosition, longFormYPosition])

                if position == longFormYPosition {
                    transition(to: .longForm)

                } else if position == shortFormYPosition || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }
            }
        }
    }
    
    /**
     판 모달이 제스처에 응답해야하는지를 결정해주는 메소드.
     판 모달이 이미 드래그 되고 있거나, 델리게이트 false 반환을 하면, 제스처가 다시 .began상태가 될 때까지 무시함.
     판 모달 제스처를 취소해야하는 유일한 경우임.
     */
    func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard
            presentable?.shouldRespond(to: panGestureRecognizer) == true ||
                !(panGestureRecognizer.state == .began || panGestureRecognizer.state == .cancelled)
            else {
                panGestureRecognizer.isEnabled = false
                panGestureRecognizer.isEnabled = true
                return false
        }
        return !shouldFail(panGestureRecognizer: panGestureRecognizer)
    }

    // 유저가 스크롤하고 있을 때 컨테이너뷰의 서브뷰들을 조정하고, 표시하기 위한 메소드.
    func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        presentable?.willRespond(to: panGestureRecognizer)

        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y

        // long form에 presented View가 고정되지 않는다면, 한계점 이상에서 이동속도를 감소시킴.
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)
        // yDisplacement를 초기화 해주기위한 함수
        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }

    /**
     특정 조건에 따라 제스처를 실패해야 하는지 여부를 결정.
     만약에 스크롤 중이면 실패.
     이를 통해 사용자는 스크롤뷰 바깥 부분 뷰컨트롤러에 대한 드래그를 할 수 있도록 함.
     그리고, 어떤 뷰에서 다른 뷰로 팬 제스처를 이동하며 제스처를 취소하면, 스크롤 전환에 대한 효과를 주지 않는것임.
     */
    func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {

        guard !shouldPrioritize(panGestureRecognizer: panGestureRecognizer) else {
            presentable?.sheetScrollView?.panGestureRecognizer.isEnabled = false
            presentable?.sheetScrollView?.panGestureRecognizer.isEnabled = true
            return false
        }

        guard
            isPresentedViewAnchored,
            let scrollView = presentable?.sheetScrollView,
            scrollView.contentOffset.y > 0
            else {
                return false
        }

        let loc = panGestureRecognizer.location(in: presentedView)
        return (scrollView.frame.contains(loc) || scrollView.isScrolling)
    }

    // Presented View의 팬 제스처가 스크롤뷰의 팬 제스처 보다 우선순위가 먼저되어야 하는지 결정하는 메소드.
    func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return panGestureRecognizer.state == .began &&
            presentable?.shouldPrioritize(panModalGestureRecognizer: panGestureRecognizer) == true
    }
    
    // 주어진 속도가 정해진 감도 범위 내에 있는지 체크하는 메소드.
    func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
        return (abs(velocity) - (1000 * (1 - Constants.snapMovementSensitivity))) > 0
    }

    func snap(toYPosition yPos: CGFloat) {
        SheetPresentationAnimator.animate({ [weak self] in
            self?.adjust(toYPosition: yPos)
            self?.isPresentedViewAnimating = true
        }, config: presentable) { [weak self] didComplete in
            self?.isPresentedViewAnimating = !didComplete
        }
    }

    // Presented View의 Y포지션을 Dimming view를 기준으로 조정, Dimming View alpha 조정 메소드.
    func adjust(toYPosition yPos: CGFloat) {
        presentedView.frame.origin.y = max(yPos, anchoredYPosition)
        
        guard presentedView.frame.origin.y > shortFormYPosition else {
            dimmingView.alpha = 1.0
            return
        }
        
        // Presented View가 shortForm 아래로 내려가면 화면 하단을 기준으로 yPos를 계산하고 DimmingView 알파에 백분율을 적용
        let yDisplacementFromShortForm = presentedView.frame.origin.y - shortFormYPosition
        dimmingView.alpha = 1.0 - (yDisplacementFromShortForm / presentedView.frame.height)
    }
    
    // 배열에 있는 CGFloat 값 중에서, 주어진 숫자과 가까운 값을 찾는 함수.
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
            else { return number }
        return nearestVal
    }
}

// MARK: - UIScrollView Observer

extension SheetPresentationController {
    
    // 주어진 스크롤뷰의 콘텐츠 offest에 옵저버를 만들고 저장함. 스크롤뷰의 델리게이트없이 스크롤링을 추적할 수 있음.
    func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in
            guard self?.containerView != nil else { return }
            self?.didPanOnScrollView(scrollView, change: change)
        }
    }
    
    /**
     Scroll View 콘텐츠 offset의 이벤트 핸들링
     스크롤이 top까지 스크롤 되면 scroll indicator를 disable해주어야 함. 아니면 글리치 발생
     panContainerView에서 scrollView로 스크롤을 원활하게 전환할 수 있게 됨.
     */
    func didPanOnScrollView(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        
        guard
            !presentedViewController.isBeingDismissed,
            !presentedViewController.isBeingPresented
            else { return }

        if !isPresentedViewAnchored && scrollView.contentOffset.y > 0 {

            haltScrolling(scrollView)

        } else if scrollView.isScrolling || isPresentedViewAnimating {

            if isPresentedViewAnchored {
                trackScrolling(scrollView)
            } else {
                haltScrolling(scrollView)
            }

        } else if presentedViewController.view.isKind(of: UIScrollView.self)
            && !isPresentedViewAnimating && scrollView.contentOffset.y <= 0 {
            
            handleScrollViewTopBounce(scrollView: scrollView, change: change)
            
        } else {
            trackScrolling(scrollView)
        }
    }

    // 스크롤이 scrollViewYOffset값에 도달하면 스크롤 멈추는 메소드.
    func haltScrolling(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
        scrollView.showsVerticalScrollIndicator = false
        
    }

    // 유저가 스크롤 할 때, 스크롤의 Y offset값을 추적하는 메소드.
    // 스크롤이 제자리에서 유지하고 있을 때, 스크롤을 멈춤.
    func trackScrolling(_ scrollView: UIScrollView) {
        scrollViewYOffset = max(scrollView.contentOffset.y, 0)
        scrollView.showsVerticalScrollIndicator = true
        
    }
    
    /**
     scrollView와 모달 사이에서 유저가 스크롤을 내릴 때
     스크롤 전환이 매끄럽게 되려면 콘텐츠 오프셋이 음수인 경우를 처리해야 함.
     이 경우 스크롤 뷰의 감속 커브를 따라야함.
     이를 통해 스크롤 뷰와 모달 뷰가 완전히 하나라는 효과를 줄 수 있음.
     */
    func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {

        // isDecelerating : 유저가 스크롤 뷰를 당기고 나서 움직이고 있을 때 리턴되는 불리언 값.
        guard let oldYValue = change.oldValue?.y, scrollView.isDecelerating else { return }

        let yOffset = scrollView.contentOffset.y
        let presentedSize = containerView?.frame.size ?? .zero

        presentedView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)

        if oldYValue > yOffset {
            presentedView.frame.origin.y = longFormYPosition - yOffset
        } else {
            scrollViewYOffset = 0
            snap(toYPosition: longFormYPosition)
        }

        scrollView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SheetPresentationController: UIGestureRecognizerDelegate {

    /**
     현재의 gesture recognizer가 다른 gesture recognizer가 제스처에 의해 인식이 실패해야 하는지. default값 false
     true : 다른 gesture recognizer가 인식 할 수 있음
     false : 현재 gesture recognizer가 인식할 수 있음
    */
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }

    // 두 개의 gestureRecognizer가 동시에 제스처를 인식해야하는지를 결정.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == presentable?.sheetScrollView
    }
}

// MARK: - Helper Extensions

private extension UIScrollView {

    // 현재 스크롤이 되고 있는지를 나타내는 Boolean 프로퍼티.
    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
