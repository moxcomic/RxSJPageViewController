//
//  RxSJPageViewControllerDataSourceProxy.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxSwift
import RxCocoa
import SJPageViewController

private let sjPageViewControllerDataSourceNotSet = SJPageViewControllerDataSourceNotSet()

private final class SJPageViewControllerDataSourceNotSet: NSObject, SJPageViewControllerDataSource {
    func numberOfViewControllers(in pageViewController: SJPageViewController) -> UInt {
        return 0
    }
    
    func pageViewController(_ pageViewController: SJPageViewController, viewControllerAt index: Int) -> UIViewController {
        return UITableViewController()
    }
    
    func viewForHeader(in pageViewController: SJPageViewController) -> UIView? {
        return nil
    }
    
    func heightForHeaderPinToVisibleBounds(with pageViewController: SJPageViewController) -> CGFloat {
        return 0
    }
    
    func modeForHeader(with pageViewController: SJPageViewController) -> SJPageViewControllerHeaderMode {
        return SJPageViewControllerHeaderModePinnedToTop
    }
}

open class RxSJPageViewControllerDataSourceProxy: DelegateProxy<SJPageViewController, SJPageViewControllerDataSource>,
                                                  DelegateProxyType,
                                                  SJPageViewControllerDataSource {
    public weak private(set) var pageViewController: SJPageViewController?
    
    public init(pageViewController: SJPageViewController) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxSJPageViewControllerDataSourceProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxSJPageViewControllerDataSourceProxy(pageViewController: $0) }
    }
    
    private weak var _requiredMethodsDataSource: SJPageViewControllerDataSource? = sjPageViewControllerDataSourceNotSet
    
    public static func currentDelegate(for object: SJPageViewController) -> SJPageViewControllerDataSource? {
        return object.dataSource
    }
    
    public static func setCurrentDelegate(_ delegate: SJPageViewControllerDataSource?, to object: SJPageViewController) {
        object.dataSource = delegate
    }
    
    public func numberOfViewControllers(in pageViewController: SJPageViewController) -> UInt {
        return (_requiredMethodsDataSource ?? sjPageViewControllerDataSourceNotSet).numberOfViewControllers(in: pageViewController)
    }
    
    public func pageViewController(_ pageViewController: SJPageViewController, viewControllerAt index: Int) -> UIViewController {
        return (_requiredMethodsDataSource ?? sjPageViewControllerDataSourceNotSet).pageViewController(pageViewController, viewControllerAt: index)
    }
    
    public override func setForwardToDelegate(_ delegate: DelegateProxy<SJPageViewController, SJPageViewControllerDataSource>.Delegate?, retainDelegate: Bool) {
        _requiredMethodsDataSource = delegate ?? sjPageViewControllerDataSourceNotSet
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
}
