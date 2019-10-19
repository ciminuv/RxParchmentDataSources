//
//  RxParchmentReactiveArrayDataSource.swift
//  RxParchment
//
//  Created by Le Phi Hung on 10/18/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//
#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import Parchment
import RxCocoa

// objc monkey business
class _RxParchmentReactiveArrayDataSource
    : NSObject
, PagingViewControllerDataSource {
  func _numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
    return 0
  }

  func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
    return _numberOfViewControllers(in: pagingViewController)
  }

  func _pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
    return UIViewController()
  }
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
    return _pagingViewController(pagingViewController, viewControllerForIndex: index)
  }

  func _pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
    return PagingIndexItem(index: 0, title: "") as! T
  }
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
    return _pagingViewController(pagingViewController, pagingItemForIndex: index)
  }

}


class RxParchmentReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>
    : RxParchmentReactiveArrayDataSource<Sequence.Element>
, RxParchmentDataSourceType {

    typealias Element = Sequence

    override init(pagingFactory: @escaping PagingFactory) {
        super.init(pagingFactory: pagingFactory)
    }

  func pagingViewController<T>(_ pagingViewController : PagingViewController<T>, observedEvent: Event<Sequence>) where T : PagingItem, T : Comparable, T : Hashable {
    Binder(self) { pagingViewControllerDataSource, sectionModels in
        let sections = Array(sectionModels)
      pagingViewControllerDataSource.pagingViewController(pagingViewController as! PagingViewController<PagingIndexItem>, observedElements: sections)
    }.on(observedEvent)
  }
}

// Please take a look at `DelegateProxyType.swift`
class RxParchmentReactiveArrayDataSource<Element>
    : _RxParchmentReactiveArrayDataSource
    , SectionedViewDataSourceType {
  typealias PagingFactory = (PagingViewController<PagingIndexItem>, Int, Element) -> (controller: UIViewController, title: String)

    var itemModels: [Element]?

    func modelAtIndex(_ index: Int) -> Element? {
        return itemModels?[index]
    }

    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }

    let pagingFactory: PagingFactory

    init(pagingFactory: @escaping PagingFactory) {
        self.pagingFactory = pagingFactory
    }

  override func _pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
    let title = pagingFactory(pagingViewController as! PagingViewController<PagingIndexItem>, index, itemModels![index]).title
    return PagingIndexItem(index: index, title: title) as! T
  }
  override func _pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
    return pagingFactory(pagingViewController as! PagingViewController<PagingIndexItem>, index, itemModels![index]).controller
  }
  override func _numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
    return itemModels?.count ?? 0
  }


  // reactive
  func pagingViewController(_ pagingViewController: PagingViewController<PagingIndexItem>, observedElements: [Element]) {
    self.itemModels = observedElements

    pagingViewController.reloadData()
  }
}

#endif
