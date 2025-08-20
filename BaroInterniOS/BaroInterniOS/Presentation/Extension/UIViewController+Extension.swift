//
//  UIViewController+Extension.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

extension UIViewController {
    func replaceRootViewController(with vc: UIViewController) {

        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        window.rootViewController = vc
    }
}
