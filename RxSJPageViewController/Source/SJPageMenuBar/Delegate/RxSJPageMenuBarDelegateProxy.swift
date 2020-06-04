//
//  RxSJPageMenuBarDelegateProxy.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/4.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SJPageViewController

open class RxSJPageMenuBarDelegateProxy:  DelegateProxy<SJPageMenuBar, SJPageMenuBarDelegate>,
                                          DelegateProxyType,
                                          SJPageMenuBarDelegate {
    public weak private(set) var pageMenuBar: SJPageMenuBar?
    
    public init(pageMenuBar: SJPageMenuBar) {
        self.pageMenuBar = pageMenuBar
        super.init(parentObject: pageMenuBar, delegateProxy: RxSJPageMenuBarDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxSJPageMenuBarDelegateProxy(pageMenuBar: $0) }
    }
    
    public static func currentDelegate(for object: SJPageMenuBar) -> SJPageMenuBarDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: SJPageMenuBarDelegate?, to object: SJPageMenuBar) {
        object.delegate = delegate
    }
}
