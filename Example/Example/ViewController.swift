//
//  ViewController.swift
//  Example
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SJPageViewController
import RxSJPageViewController
import NSObject_Rx

class ViewController: UIViewController {
    fileprivate lazy var subject = BehaviorSubject(value: [SectionModel<String, String>]())
    
    fileprivate lazy var pageViewController = SJPageViewController()
    
    fileprivate lazy var pageMenuBar: SJPageMenuBar = {
        $0.distribution = SJPageMenuBarDistributionFillEqually
        $0.scrollIndicatorLayoutMode = SJPageMenuBarScrollIndicatorLayoutModeEqualItemViewContentWidth
        return $0
    }(SJPageMenuBar(frame: CGRect(x: 0, y: 300 - 44, width: UIScreen.main.bounds.width, height: 44)))
    
    // HeaderView一定要在外面定义，如果在configureHeaderView内定义则添加在HeaderView上的子控件将不会显示
    fileprivate lazy var headerView: UIView = {
        $0.backgroundColor = #colorLiteral(red: 0.2120229304, green: 0.6384014487, blue: 0.960485518, alpha: 1)
        $0.addSubview(self.pageMenuBar)
        return $0
    }(UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.view.frame = self.view.bounds
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        let dataSource = RxSJPageViewControllerReloadDataSource<SectionModel<String, String>>(configureViewController: {
            (_, pageVC, index, element) in
            switch element.identity {
            case "a": return UITableViewController()
            case "b", "c": return UITableViewController()
            default: return UITableViewController()
            }
        }, configureHeaderView: { _, _ in
            return (self.headerView, 44 + 44, SJPageViewControllerHeaderModePinnedToTop)
        })
        self.subject.asObserver().bind(to: self.pageViewController.rx.pages(dataSource: dataSource)).disposed(by: rx.disposeBag)
        self.pageMenuBar.itemViews = ["AAAA", "BBBB", "CCCC"].map { SJPageMenuItemView($0) }
        
        self.pageMenuBar.rx.focusedIndexDidChange.bind { [weak self] (pageMenuBar, index) in
            guard let self = self else { return }
            if !self.pageViewController.isViewControllerVisible(at: index) {
                self.pageViewController.setViewControllerAt(index)
            }
        }.disposed(by: rx.disposeBag)
        
        subject.onNext([SectionModel<String, String>(model: "", items: ["AAAA", "BBBB", "CCCC"])])
        
        pageViewController.rx.didScrollIn.bind { [weak self] (pageViewController, range, progress) in
            guard let self = self else { return }
            self.pageMenuBar.scroll(in: range, distanceProgress: progress)
        }.disposed(by: rx.disposeBag)
    }
}


class ViewControllerUseDelegate: UIViewController, SJPageViewControllerDelegate, SJPageViewControllerDataSource, SJPageMenuBarDelegate {
    fileprivate lazy var pageViewController = SJPageViewController()
    
    fileprivate lazy var pageMenuBar: SJPageMenuBar = {
        $0.distribution = SJPageMenuBarDistributionFillEqually
        $0.scrollIndicatorLayoutMode = SJPageMenuBarScrollIndicatorLayoutModeEqualItemViewContentWidth
        return $0
    }(SJPageMenuBar(frame: CGRect(x: 0, y: 300 - 44, width: UIScreen.main.bounds.width, height: 44)))
    
    fileprivate lazy var headerView: UIView = {
        $0.backgroundColor = #colorLiteral(red: 0.2120229304, green: 0.6384014487, blue: 0.960485518, alpha: 1)
        $0.addSubview(self.pageMenuBar)
        return $0
    }(UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.view.frame = self.view.bounds
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
    }
    
    func numberOfViewControllers(in pageViewController: SJPageViewController) -> UInt {
        return 3
    }
    
    func pageViewController(_ pageViewController: SJPageViewController, viewControllerAt index: Int) -> UIViewController {
        switch index {
        case 0: return UITableViewController()
        case 1, 2: return UITableViewController()
        default: return UITableViewController()
        }
    }
    
    func viewForHeader(in pageViewController: SJPageViewController) -> UIView? {
        return headerView
    }
    
    func heightForHeaderPinToVisibleBounds(with pageViewController: SJPageViewController) -> CGFloat {
        return 300
    }
    
    func modeForHeader(with pageViewController: SJPageViewController) -> SJPageViewControllerHeaderMode {
        return SJPageViewControllerHeaderModePinnedToTop
    }
    
    func pageViewController(_ pageViewController: SJPageViewController, didScrollIn range: NSRange, distanceProgress progress: CGFloat) {
        self.pageMenuBar.scroll(in: range, distanceProgress: progress)
    }
    
    func pageMenuBar(_ bar: SJPageMenuBar, focusedIndexDidChange index: UInt) {
        if !self.pageViewController.isViewControllerVisible(at: Int(index)) {
            self.pageViewController.setViewControllerAt(Int(index))
        }
    }
}
