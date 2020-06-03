//
//  RxSJPageViewControllerReloadDataSource.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxSwift
import RxCocoa
import Differentiator
import SJPageViewController

open class RxSJPageViewControllerReloadDataSource<Section: SectionModelType>: SJPageViewControllerSectionedDataSource<Section>,
                                                                              RxSJPageViewControllerDataSourceType {
    public typealias Element = [Section]

    open func pageViewController(_ pageViewController: SJPageViewController, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            #if DEBUG
                dataSource._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            pageViewController.reload()
        }.on(observedEvent)
    }
}
