//
//  RxSJPageViewControllerDataSourceType.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxSwift
import SJPageViewController

public protocol RxSJPageViewControllerDataSourceType {
    associatedtype Element
    
    func pageViewController(_ pageViewController: SJPageViewController, observedEvent: Event<Element>)
}
