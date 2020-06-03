//
//  SJPageViewController+Rx.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SJPageViewController

extension Reactive where Base: SJPageViewController {
    public func pages<
            DataSource: RxSJPageViewControllerDataSourceType & SJPageViewControllerDataSource,
            Source: ObservableType>
        (dataSource: DataSource)
        -> (_ source: Source)
        -> Disposable
        where DataSource.Element == Source.Element {
        return { source in
            // This is called for sideeffects only, and to make sure delegate proxy is in place when
            // data source is being bound.
            // This is needed because theoretically the data source subscription itself might
            // call `self.rx.delegate`. If that happens, it might cause weird side effects since
            // setting data source will set delegate, and UITableView might get into a weird state.
            // Therefore it's better to set delegate proxy first, just to be sure.
            _ = self.delegate
            // Strong reference is needed because data source is in use until result subscription is disposed
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource as SJPageViewControllerDataSource, retainDataSource: true) { [weak pageViewController = self.base] (_: RxSJPageViewControllerDataSourceProxy, event) -> Void in
                guard let pageViewController = pageViewController else {
                    return
                }
                dataSource.pageViewController(pageViewController, observedEvent: event)
            }
        }
    }
}

extension Reactive where Base: SJPageViewController {
    public var delegate: RxSJPageViewControllerDelegateProxy {
        return RxSJPageViewControllerDelegateProxy.proxy(for: base)
    }
    
    public var headerViewVisibleRectDidChange: ControlEvent<(pageViewController: SJPageViewController, visibleRect: CGRect)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewController(_:headerViewVisibleRectDidChange:)))
            .map { (a) -> (pageViewController: SJPageViewController, visibleRect: CGRect) in
                return (try castOrThrow(SJPageViewController.self,a[0]),
                        try castOrThrow(CGRect.self, a[1]))
        }
        return ControlEvent(events: source)
    }
    
    public var didScrollIn: ControlEvent<(pageViewController: SJPageViewController, range: NSRange, progress: CGFloat)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewController(_:didScrollIn:distanceProgress:)))
            .map { (a) -> (pageViewController: SJPageViewController, range: NSRange, progress: CGFloat) in
                return (try castOrThrow(SJPageViewController.self, a[0]),
                        try castOrThrow(NSRange.self, a[1]),
                        try castOrThrow(CGFloat.self, a[2]))
        }
        return ControlEvent(events: source)
    }
    
    public var focusedIndexDidChange: ControlEvent<(pageViewController: SJPageViewController, index: Int)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewController(_:focusedIndexDidChange:)))
            .map { (a) -> (pageViewController: SJPageViewController, index: Int) in
                return (try castOrThrow(SJPageViewController.self, a[0]),
                        try castOrThrow(Int.self, a[1]))
        }
        return ControlEvent(events: source)
    }
    
    public var willDisplay: ControlEvent<(pageViewController: SJPageViewController, viewController: UIViewController?, index: Int)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewController(_:willDisplay:at:)))
            .map { (a) -> (pageViewController: SJPageViewController, viewController: UIViewController?, index: Int) in
                return (try castOrThrow(SJPageViewController.self, a[0]),
                        try castOrThrow(UIViewController.self, a[1]),
                        try castOrThrow(Int.self, a[2]))
        }
        return ControlEvent(events: source)
    }
    
    public var didEndDisplaying: ControlEvent<(pageViewController: SJPageViewController, viewController: UIViewController?, index: Int)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewController(_:didEndDisplaying:at:)))
            .map { (a) -> (pageViewController: SJPageViewController, viewController: UIViewController?, index: Int) in
                return (try castOrThrow(SJPageViewController.self, a[0]),
                        try castOrThrow(UIViewController.self, a[1]),
                        try castOrThrow(Int.self, a[2]))
        }
        return ControlEvent(events: source)
    }
}
