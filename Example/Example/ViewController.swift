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
        })
        self.subject.asObserver().bind(to: self.pageViewController.rx.pages(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        subject.onNext([SectionModel<String, String>(model: "", items: ["a", "b", "c"])])
        
        pageViewController.rx.didScrollIn.bind { (pageViewController, range, progress) in
            print("scroll to \(range) - \(progress)")
        }.disposed(by: rx.disposeBag)
    }
}
