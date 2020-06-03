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
    
    public init(configureViewController: @escaping ConfigureViewController) {
        self.configureViewController = configureViewController
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
        self._sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
        print("sections: \(sections)")
    }
    
    open var configureViewController: ConfigureViewController {
        didSet {
            print("configureViewController set")
        }
    }
    
    public func numberOfViewControllers(in pageViewController: SJPageViewController) -> UInt {
        return UInt(_sectionModels[0].items.count)
    }
    
    public func pageViewController(_ pageViewController: SJPageViewController, viewControllerAt index: Int) -> UIViewController {
        let indexPath = IndexPath(item: index, section: 0)
        return configureViewController(self, pageViewController, index, self[indexPath])
    }
}
