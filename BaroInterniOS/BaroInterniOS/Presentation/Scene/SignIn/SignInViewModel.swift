//
//  SignInViewModel.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import RxSwift
import RxRelay
import RxCocoa
import CoreData

final class SignInViewModel {

    private let userDataUseCase: UserDataUseCase
    private let memberDataUseCase: MemberDataUseCase
    private let validationUseCase: ValidationUseCaseProtocol

    // MARK: - Actions
    enum Action {
        case didTapSignUpButton
        case userIDChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        case nicknameChanged(String)
    }

    enum Route {
        case rootMain
        case showAlert(String)
    }
    // MARK: - States
    struct State {
        let route: Signal<Route>
        let isSignUpButtonEnabled: Driver<Bool>
        let userIDValidationMessage: Driver<String?>
        let passwordValidationMessage: Driver<String?>
        let confirmPasswordValidationMessage: Driver<String?>
    }

    // MARK: - Inputs
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Outputs
    private let _action = PublishSubject<Action>()
    private let _routeRelay = PublishRelay<Route>()
    private let _userIDRelay = BehaviorRelay<String>(value: "")
    private let _passwordRelay = BehaviorRelay<String>(value: "")
    private let _confirmPasswordRelay = BehaviorRelay<String>(value: "")
    private let _nicknameRelay = BehaviorRelay<String>(value: "")

    private let disposeBag = DisposeBag()

    // MARK: - Initializer
    init(
        userDataUseCase: UserDataUseCase,
        memberDataUseCase: MemberDataUseCase,
        validationUseCase: ValidationUseCaseProtocol
    ) {
        self.userDataUseCase = userDataUseCase
        self.memberDataUseCase = memberDataUseCase
        self.validationUseCase = validationUseCase

        state = State(
            route: _routeRelay.asSignal(),
            isSignUpButtonEnabled: validationUseCase.createIsSignUpButtonEnabled(
                userID: _userIDRelay.asObservable(),
                password: _passwordRelay.asObservable(),
                confirmPassword: _confirmPasswordRelay.asObservable(),
                nickname: _nicknameRelay.asObservable()
            ),
            userIDValidationMessage: validationUseCase.createUserIDValidationMessage(from: _userIDRelay.asObservable()),
            passwordValidationMessage: validationUseCase.createPasswordValidationMessage(from: _passwordRelay.asObservable()),
            confirmPasswordValidationMessage: validationUseCase.createConfirmPasswordValidationMessage(
                password: _passwordRelay.asObservable(),
                confirmPassword: _confirmPasswordRelay.asObservable()
            )
        )

        bindAction()
    }

    // MARK: - Bind
    private func bindAction() {
        _action
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, action in
                switch action {
                case .didTapSignUpButton:
                    owner.signUp()
                case .userIDChanged(let userID):
                    owner._userIDRelay.accept(userID)
                case .passwordChanged(let password):
                    owner._passwordRelay.accept(password)
                case .confirmPasswordChanged(let confirmPassword):
                    owner._confirmPasswordRelay.accept(confirmPassword)
                case .nicknameChanged(let nickname):
                    owner._nicknameRelay.accept(nickname)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: Methods
    private func signUp() {
        let userID = _userIDRelay.value
        let password = _passwordRelay.value
        let nickname = _nicknameRelay.value

        if userDataUseCase.isUserIDExist(userID: userID) {
            _routeRelay.accept(.showAlert("이미 사용 중인 이메일 주소입니다."))
            return
        }

        userDataUseCase.signUp(userID: userID, password: password, nickName: nickname)
        memberDataUseCase.saveMemeberData(userID: userID)
        _routeRelay.accept(.rootMain)
    }
}

