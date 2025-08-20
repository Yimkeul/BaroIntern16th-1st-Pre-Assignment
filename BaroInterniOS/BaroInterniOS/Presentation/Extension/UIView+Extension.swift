//
//  UIView+Extension.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
