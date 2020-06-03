//
//  SJPageViewControllerSectionedDataSource.swift
//  RxSJPageViewController
//
//  Created by 神崎H亚里亚 on 2020/6/2.
//  Copyright © 2020 moxcomic. All rights reserved.
//

import RxCocoa
import Differentiator
import SJPageViewController

open class SJPageViewControllerSectionedDataSource<Section: SectionModelType>: NSObject,
                                                                               SJPageViewControllerDataSource,
                                                                               SectionedViewDataSourceType {
    
    public typealias Item = Section.Item
    
    public typealias ConfigureViewController = (SJPageViewControllerSectionedDataSource<Section>, SJPageViewController, Int, Item) -> UIViewController
    public typealias ConfigureHeaderView = (SJPageViewControllerSectionedDataSource<Section>, SJPageViewController) -> (UIView?, CGFloat, SJPageViewControllerHeaderMode)?
    
    public init(
        configureViewController: @escaping ConfigureViewController,
        configureHeaderView: @escaping ConfigureHeaderView = { _, _ in nil }) {
        self.configureViewController = configureViewController
        self.configureHeaderView = configureHeaderView
    }
    
    var _dataSourceBound: Bool = false
    
    public typealias SectionModelSnapshot = SectionModel<Section, Item>
    
    private var _sectionModels: [SectionModelSnapshot] = []

    open var sectionModels: [Section] {
        return _sectionModels.map { Section(original: $0.model, items: $0.items) }
    }
    
    public subscript(section: Int) -> Section {
        let sectionModel = self._sectionModels[section]
        return Section(original: sectionModel.model, items: sectionModel.items)
    }

    public subscript(indexPath: IndexPath) -> Item {
        get {
            return self._sectionModels[indexPath.section].items[indexPath.item]
        }
        set(item) {
            var section = self._sectionModels[indexPath.section]
            section.items[indexPath.item] = item
            self._sectionModels[indexPath.section] = section
        }
    }
    
    public func model(at indexPath: IndexPath) throws -> Any {
        return self[indexPath]
    }
    
    open func setSections(_ sections: [Section]) {
        #if DEBUG
        print("sections: \(sections)")
        #endif
        self._sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    open var configureViewController: ConfigureViewController {
        didSet {
            #if DEBUG
            print("configureViewController set")
            #endif
        }
    }
    
    open var configureHeaderView: ConfigureHeaderView {
        didSet {
            #if DEBUG
            print("configureHeaderView set")
            #endif
        }
    }
    
    public func numberOfViewControllers(in pageViewController: SJPageViewController) -> UInt {
        return UInt(_sectionModels[0].items.count)
    }
    
    public func pageViewController(_ pageViewController: SJPageViewController, viewControllerAt index: Int) -> UIViewController {
        let indexPath = IndexPath(item: index, section: 0)
        return configureViewController(self, pageViewController, index, self[indexPath])
    }
    
    public func viewForHeader(in pageViewController: SJPageViewController) -> UIView? {
        return configureHeaderView(self, pageViewController)?.0
    }
    
    public func heightForHeaderPinToVisibleBounds(with pageViewController: SJPageViewController) -> CGFloat {
        return configureHeaderView(self, pageViewController)?.1 ?? 0
    }
    
    public func modeForHeader(with pageViewController: SJPageViewController) -> SJPageViewControllerHeaderMode {
        return configureHeaderView(self, pageViewController)?.2 ?? SJPageViewControllerHeaderModePinnedToTop
    }
}
