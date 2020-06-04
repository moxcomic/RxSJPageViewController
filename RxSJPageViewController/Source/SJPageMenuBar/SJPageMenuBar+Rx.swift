//
//  SJPageMenuBar+Rx.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/4.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SJPageViewController

extension Reactive where Base: SJPageMenuBar {
    public var delegate: RxSJPageMenuBarDelegateProxy {
        return RxSJPageMenuBarDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: SJPageMenuBarDelegate)
        -> Disposable {
            return RxSJPageMenuBarDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    public var focusedIndexDidChange: ControlEvent<(pageMenuBar: SJPageMenuBar, index: Int)> {
        let source = delegate.methodInvoked(#selector(SJPageMenuBarDelegate.pageMenuBar(_:focusedIndexDidChange:)))
            .map { (a) -> (pageMenuBar: SJPageMenuBar, index: Int) in
                return (try castOrThrow(SJPageMenuBar.self, a[0]),
                        try castOrThrow(Int.self, a[1]))
        }
        return ControlEvent(events: source)
    }
}
