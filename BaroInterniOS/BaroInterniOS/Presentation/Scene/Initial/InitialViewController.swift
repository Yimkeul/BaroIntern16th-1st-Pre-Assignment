//
//  InitialViewController.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit
import RxSwift
import RxCocoa

final class InitialViewController: UIViewController {

    private let initialView = InitialView()
    private let viewModel: InitialViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: InitialViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = initialView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        bindView()
        bindViewModel()
    }

    // MARK: - Bind
    private func bindView() {
        initialView.startButton.rx.tap
            .asDriver()
            .map { .didTapStart }
            .drive(viewModel.action)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.route
            .emit(with: self) { owner, state in
                switch state {
                case .pushSignIn:
                    let vc = DIContainer.shared.makeSignInViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .rootMain:
                    let vc = DIContainer.shared.makeMainViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    self.replaceRootViewController(with: nav)
                }
            }
            .disposed(by: disposeBag)
    }
}
