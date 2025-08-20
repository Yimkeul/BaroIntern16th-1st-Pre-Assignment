//
//  UIStackView+Extension.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

