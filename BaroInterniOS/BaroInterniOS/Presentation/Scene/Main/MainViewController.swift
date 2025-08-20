//
//  MainViewController.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MainViewController: UIViewController {

    private let mainView = MainView()
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() { view = mainView }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    // MARK: - Bind
    private func bindView() {
        mainView.logoutButton.rx.tap
            .map { MainViewModel.Action.didTapLogout }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        mainView.deleteAccountButton.rx.tap
            .map { MainViewModel.Action.didTapDeleteAccount }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.nickname
            .drive(with: self) { owner, state in
                owner.mainView.configureMessage(nickname: state)
            }
            .disposed(by: disposeBag)

        viewModel.state.route
            .emit(with: self) { owner, state in
                switch state {
                case .rootInitial:
                    let vc = DIContainer.shared.makeInitialViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    owner.replaceRootViewController(with: nav)
                }
            }
            .disposed(by: disposeBag)
    }
}
