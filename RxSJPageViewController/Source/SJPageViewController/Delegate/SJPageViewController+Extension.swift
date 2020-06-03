//
//  SJPageViewController+Extension.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxSwift
import RxCocoa
import SJPageViewController

extension SJPageViewController: HasDelegate, HasDataSource {
    public typealias Delegate = SJPageViewControllerDelegate
    
    public typealias DataSource = SJPageViewControllerDataSource
}
