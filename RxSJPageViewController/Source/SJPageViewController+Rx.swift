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
        return { (source) in
            _ = self.delegate
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
    
    public func setDelegate(_ delegate: SJPageViewControllerDelegate)
        -> Disposable {
            return RxSJPageViewControllerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
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
    
    public var pageViewControllerDidScroll: ControlEvent<(SJPageViewController)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewControllerDidScroll(_:)))
            .map { (a) -> (SJPageViewController) in
                return try castOrThrow(SJPageViewController.self, a[0])
        }
        return ControlEvent(events: source)
    }
    
    public var pageViewControllerWillBeginDragging: ControlEvent<(SJPageViewController)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewControllerWillBeginDragging(_:)))
            .map { (a) -> (SJPageViewController) in
                return try castOrThrow(SJPageViewController.self, a[0])
        }
        return ControlEvent(events: source)
    }
    
    public var pageViewControllerDidEndDragging: ControlEvent<(pageViewController: SJPageViewController, decelerate: Bool)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewControllerDidEndDragging(_:willDecelerate:)))
            .map { (a) -> (pageViewController: SJPageViewController, decelerate: Bool) in
                return (try castOrThrow(SJPageViewController.self, a[0]),
                        try castOrThrow(Bool.self, a[1]))
        }
        return ControlEvent(events: source)
    }
    
    public var pageViewControllerWillBeginDecelerating: ControlEvent<(SJPageViewController)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewControllerWillBeginDecelerating(_:)))
            .map { (a) -> (SJPageViewController) in
                return try castOrThrow(SJPageViewController.self, a[0])
        }
        return ControlEvent(events: source)
    }
    
    public var pageViewControllerDidEndDecelerating: ControlEvent<(SJPageViewController)> {
        let source = delegate.methodInvoked(#selector(SJPageViewControllerDelegate.pageViewControllerDidEndDecelerating(_:)))
            .map { (a) -> (SJPageViewController) in
                return try castOrThrow(SJPageViewController.self, a[0])
        }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: SJPageViewController {
    public var dataSource: DelegateProxy<SJPageViewController, SJPageViewControllerDataSource> {
        return RxSJPageViewControllerDataSourceProxy.proxy(for: base)
    }
    
    public func setDataSource(_ dataSource: SJPageViewControllerDataSource)
        -> Disposable {
            return RxSJPageViewControllerDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }
}
