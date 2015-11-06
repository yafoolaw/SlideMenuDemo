//
//  SlideMenuController.swift
//  SlideMenuDemo
//
//  Created by FrankLiu on 15/11/5.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

struct SlideMenuOptions {
    
    static var leftViewWidth:     CGFloat = 270
    static var animationDuration: CGFloat = 0.4
    static var contentViewScale:  CGFloat = 0.9
}

public class SlideMenuController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: 变量
    var mainContainerView  = UIView()
    var leftContainerView  = UIView()
    
    var mainVC:  UIViewController?
    var leftVC:  UIViewController?
    
    var leftTapGesture:  UITapGestureRecognizer?
    
    // MARK: 基本初始化
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: 便利构造器
    convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
    
        self.init()
        
        mainVC = mainViewController
        leftVC = leftMenuViewController
        
        initView()
        
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewWillLayoutSubviews() {
        
        setUpViewController(mainContainerView, targetViewController: mainVC)
        setUpViewController(leftContainerView, targetViewController: leftVC)
    }
    
    func initView() {
    
        // mainContainView
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.backgroundColor = UIColor.clearColor()
        view.insertSubview(mainContainerView, atIndex: 0)
        
        // leftContainerView
        var leftFrame: CGRect = view.bounds
        leftFrame.size.width = SlideMenuOptions.leftViewWidth
        leftFrame.origin.x = leftMinOrigin()
        
        leftContainerView = UIView(frame: leftFrame)
        leftContainerView.backgroundColor = UIColor.clearColor()
        view.insertSubview(leftContainerView, atIndex: 1)
        
        addLeftGesture()
    }
    
    // MARK: 手势相关方法
   public func addLeftGesture() {
    
        if leftVC != nil {
        
            if leftTapGesture == nil {
            
                leftTapGesture = UITapGestureRecognizer(target: self, action: "toggleLeft")
                leftTapGesture?.delegate = self
                view.addGestureRecognizer(leftTapGesture!)
            }
            
        }
    }
    
    override func toggleLeft() {
    
        if isLeftOpen() {
        
            closeLeft()
            
        } else {
         
            openLeft()
        }
    }
    
    func isLeftOpen() -> Bool {
    
        return leftContainerView.frame.origin.x == 0
    }
    
    func isLeftHidden() -> Bool {
    
        return leftContainerView.frame.origin.x <= leftMinOrigin()
    }
    
    func leftMinOrigin() -> CGFloat {
    
        return -SlideMenuOptions.leftViewWidth
    }
    
    override func openLeft() {
    
        leftVC?.beginAppearanceTransition(isLeftHidden(), animated: true)
        openLeftWithVelocity(0)
    }
    
    func openLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = 0
        
        var frame: CGRect = leftContainerView.frame
        
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin)/velocity)
            
            duration = Double(fmax(0.1, fmin(1, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.leftContainerView.frame = frame

                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(SlideMenuOptions.contentViewScale, SlideMenuOptions.contentViewScale)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                
                    strongSelf.leftVC?.endAppearanceTransition()
                }
        }
    }
    
    override func closeLeft() {
    
        leftVC?.beginAppearanceTransition(isLeftHidden(), animated: true)
        closeLeftWithVelocity(0)
    }
    
    func closeLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = leftMinOrigin()
        
        var frame: CGRect = leftContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin)/velocity)
            
            duration = Double(fmax(0.1, fmin(1, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.leftContainerView.frame = frame
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                    
                    strongSelf.leftVC?.endAppearanceTransition()
                }
                
        }
    }
    
    func isPointContainedWithinLeftRect(point: CGPoint) -> Bool {
        
        return CGRectContainsPoint(leftContainerView.frame, point)
    }
    
    //MARK: – UIGestureRecognizerDelegate
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let point: CGPoint = touch.locationInView(view)
        
        if gestureRecognizer == leftTapGesture {
            
            return isLeftOpen() && !isPointContainedWithinLeftRect(point)
            
        }
        
        return true
    }
    
    // MARK: 容器控制器相关方法
    func setUpViewController(targetView: UIView, targetViewController: UIViewController?) {
        
        if let viewController = targetViewController {
            
            addChildViewController(viewController)
            
            viewController.view.frame = targetView.bounds
            
            targetView.addSubview(viewController.view)
            
            viewController.didMoveToParentViewController(self)
            
        }
    }
    
    func removeViewController(viewController: UIViewController?) {
        
        if let _viewController = viewController {
            
            _viewController.willMoveToParentViewController(nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    func changeMainViewController(mainViewController: UIViewController) {
        
        removeViewController(mainVC)
        
        mainVC = mainViewController
        
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        
        closeLeft()
    }

}

extension UIViewController {

    public func slideMenuController() -> SlideMenuController? {
        
        var viewController: UIViewController? = self
        
        while viewController != nil {
            
            if viewController is SlideMenuController {
                
                return viewController as? SlideMenuController
            }
            
            viewController = viewController?.parentViewController
        }
        
        return nil
    }
    
    public func addLeftBarButtonWithImage(buttonImage: UIImage) {
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: .Plain, target: self, action: "toggleLeft")
        
        navigationItem.leftBarButtonItem = leftButton
    }
}
