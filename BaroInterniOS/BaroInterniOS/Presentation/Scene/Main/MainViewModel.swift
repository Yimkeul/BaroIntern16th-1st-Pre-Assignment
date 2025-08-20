//
//  MainViewModel.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa
import CoreData

final class MainViewModel {

    private let userDataUseCase: UserDataUseCase
    private let memberDataUseCase: MemberDataUseCase

    // MARK: - Actions
    enum Action {
        case didTapLogout
        case didTapDeleteAccount
    }

    enum Route {
        case rootInitial
    }

    // MARK: - States
    struct State {
        let route: Signal<Route>
        let nickname: Driver<String>
    }

    // MARK: - Inputs
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Outputs
    private let _action = PublishSubject<Action>()
    private let _routeRelay = PublishRelay<Route>()
    private let _nicknameRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()


    // MARK: - Initializer
    init(
        userDataUseCase: UserDataUseCase,
        memberDataUseCase: MemberDataUseCase
    ) {

        self.userDataUseCase = userDataUseCase
        self.memberDataUseCase = memberDataUseCase

        state = State(
            route: _routeRelay.asSignal(),
            nickname: _nicknameRelay.asDriver()
        )
        bindAction()
        setNickName()
    }


    // MARK: - Bind
    private func bindAction() {
        _action
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, action in
            switch action {
            case .didTapLogout:
                owner.logOut()
            case .didTapDeleteAccount:
                owner.deleteAccount()
            }
        }.disposed(by: disposeBag)
    }

    // MARK: Methods
    private func setNickName() {
        guard let userID = memberDataUseCase.fetchMemberID(),
        let nickname = userDataUseCase.fetchNickname(by: userID)
        else {
            _routeRelay.accept(.rootInitial)
            return
        }

        _nicknameRelay.accept(nickname)
    }


    private func logOut() {
        _routeRelay.accept(.rootInitial)
    }

    private func deleteAccount() {
        guard let userID = memberDataUseCase.fetchMemberID() else {
            _routeRelay.accept(.rootInitial)
            return
        }
        userDataUseCase.deleteUser(userID: userID)
        memberDataUseCase.deleteMemberData(userID: userID)
        _routeRelay.accept(.rootInitial)
    }

}
