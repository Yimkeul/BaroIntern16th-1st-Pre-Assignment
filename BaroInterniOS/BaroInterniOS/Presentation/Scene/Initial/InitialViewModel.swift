//
//  InitialViewModel.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class InitialViewModel: ViewModel {

    private let memberDataUseCase: MemberDataUseCase

    // MARK: - Actions
    enum Action {
        case didTapStart
    }

    enum Route {
        case pushSignIn
        case rootMain
    }

    // MARK: - States
    struct State {
        let route: Signal<Route>
    }

    // MARK: - Inputs
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Outputs
    private let _action = PublishSubject<Action>()
    private let _routeRelay = PublishRelay<Route>()
    private let disposeBag = DisposeBag()

    // MARK: - Initializer
    init(memberDataUseCase: MemberDataUseCase) {
        self.memberDataUseCase = memberDataUseCase
        state = State(route: _routeRelay.asSignal())
        bindAction()
    }

    // MARK: - Bind
    private func bindAction() {
        _action
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, action in
                switch action {
                case .didTapStart:
                    owner.routing()
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: Methods
    private func routing() {
        if memberDataUseCase.checkMemberData() {
            _routeRelay.accept(.rootMain)
        } else {
            _routeRelay.accept(.pushSignIn)
        }
    }
}
