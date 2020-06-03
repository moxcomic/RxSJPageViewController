//
//  RxSJPageViewControllerDelegateProxy.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxSwift
import RxCocoa
import SJPageViewController

open class RxSJPageViewControllerDelegateProxy: DelegateProxy<SJPageViewController,SJPageViewControllerDelegate>,
                                                DelegateProxyType,
                                                SJPageViewControllerDelegate {
    
    public weak private(set) var pageViewController: SJPageViewController?
    
    public init(pageViewController: SJPageViewController) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxSJPageViewControllerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxSJPageViewControllerDelegateProxy(pageViewController: $0) }
    }
    
    public static func currentDelegate(for object: SJPageViewController) -> SJPageViewControllerDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: SJPageViewControllerDelegate?, to object: SJPageViewController) {
        object.delegate = delegate
    }
}
