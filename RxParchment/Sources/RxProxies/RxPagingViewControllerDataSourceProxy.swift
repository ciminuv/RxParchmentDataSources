//
//  RxPagingViewControllerDataSourceProxy.swift
//  RxParchment
//
//  Created by Le Phi Hung on 10/19/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import Parchment
import RxCocoa

let dataSourceNotSet = "DataSource not set"
let delegateNotSet = "Delegate not set"


extension PagingViewController: HasDataSource{
    public typealias DataSource = PagingViewControllerDataSource
}

private let pagingViewDataSourceNotSet = PagingViewDataSourceNotSet()

private final class PagingViewDataSourceNotSet
    : NSObject
    , PagingViewControllerDataSource {

  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
    return PagingIndexItem(index: index, title: "") as! T
  }
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
    rxAbstractMethod(message: dataSourceNotSet)
  }

  func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
    return 0
  }
}
/// For more information take a look at `DelegateProxyType`.
open class RxPagingViewControllerDataSourceProxy
    : DelegateProxy<PagingViewController<PagingIndexItem>, PagingViewControllerDataSource>
    , DelegateProxyType
, PagingViewControllerDataSource {


    /// Typed parent object.
    public weak private(set) var pagingViewController: PagingViewController<PagingIndexItem>?

    /// - parameter tableView: Parent object for delegate proxy.
    public init(pagingViewController: PagingViewController<PagingIndexItem>) {
        self.pagingViewController = pagingViewController
        super.init(parentObject: pagingViewController, delegateProxy: RxPagingViewControllerDataSourceProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxPagingViewControllerDataSourceProxy(pagingViewController: $0) }
    }

    private weak var _requiredMethodsDataSource: PagingViewControllerDataSource? = pagingViewDataSourceNotSet

    // MARK: delegate

  public func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
    return (_requiredMethodsDataSource ?? pagingViewDataSourceNotSet).numberOfViewControllers(in: pagingViewController)
  }

  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
    return (_requiredMethodsDataSource ?? pagingViewDataSourceNotSet).pagingViewController(pagingViewController, viewControllerForIndex: index)
  }

  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
    return (_requiredMethodsDataSource ?? pagingViewDataSourceNotSet).pagingViewController(pagingViewController, pagingItemForIndex: index)
  }

  /// For more information take a look at `DelegateProxyType`.
  open override func setForwardToDelegate(_ forwardToDelegate: PagingViewControllerDataSource?, retainDelegate: Bool) {
    _requiredMethodsDataSource = forwardToDelegate  ?? pagingViewDataSourceNotSet
    super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
  }

}
#endif
