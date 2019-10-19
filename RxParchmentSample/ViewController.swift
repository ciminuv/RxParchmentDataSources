//
//  ViewController.swift
//  RxParchmentSample
//
//  Created by Le Phi Hung on 10/19/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

import UIKit
import RxParchment
import Parchment
import RxSwift

class ViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    let pagingViewController = PagingViewController<PagingIndexItem>()
    pagingViewController.delegate = self

    addChild(pagingViewController)
    containerView.addSubview(pagingViewController.view)
    containerView.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)

    let items = Observable.of(["A","B","C"])
    items.bind(to: pagingViewController.rx.items) { (pagingViewController: PagingViewController<PagingIndexItem>, index: Int, element: String) -> (controller: UIViewController, title: String) in
      return (controller: ItemViewController(item: element), title: element)
       }.disposed(by: disposeBag)
  }

}


extension ViewController: PagingViewControllerDelegate {

  // We want the size of our paging items to equal the width of the
  // city title. Parchment does not support self-sizing cells at
  // the moment, so we have to handle the calculation ourself. We
  // can access the title string by casting the paging item to a
  // PagingTitleItem, which is the PagingItem type used by
  // FixedPagingViewController.
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? {
    guard let item = pagingItem as? PagingIndexItem else { return 0 }

    let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
    let attributes = [NSAttributedString.Key.font: pagingViewController.font]

    let rect = item.title.boundingRect(with: size,
      options: .usesLineFragmentOrigin,
      attributes: attributes,
      context: nil)

    let width = ceil(rect.width) + insets.left + insets.right

    if isSelected {
      return width * 1.5
    } else {
      return width
    }
  }

}

extension UIView {

  func constrainCentered(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false

    let verticalContraint = NSLayoutConstraint(
      item: subview,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerY,
      multiplier: 1.0,
      constant: 0)

    let horizontalContraint = NSLayoutConstraint(
      item: subview,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerX,
      multiplier: 1.0,
      constant: 0)

    let heightContraint = NSLayoutConstraint(
      item: subview,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: subview.frame.height)

    let widthContraint = NSLayoutConstraint(
      item: subview,
      attribute: .width,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: subview.frame.width)

    addConstraints([
      horizontalContraint,
      verticalContraint,
      heightContraint,
      widthContraint])

  }

  func constrainToEdges(_ subview: UIView) {

    subview.translatesAutoresizingMaskIntoConstraints = false

    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0)

    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 0)

    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1.0,
      constant: 0)

    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: 1.0,
      constant: 0)

    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint])
  }

}
