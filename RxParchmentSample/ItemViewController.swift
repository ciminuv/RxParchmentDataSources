//
//  ItemViewController.swift
//  RxParchmentSample
//
//  Created by Le Phi Hung on 10/19/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

   init(item: String) {
      super.init(nibName: nil, bundle: nil)
      title = "View " + item

      let label = UILabel(frame: .zero)
      label.font = UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.thin)
      label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
      label.text = item
      label.sizeToFit()

      view.addSubview(label)
      view.constrainCentered(label)
      view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

}
