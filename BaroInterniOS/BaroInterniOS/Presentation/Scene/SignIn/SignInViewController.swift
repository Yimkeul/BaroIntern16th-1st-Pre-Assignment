//
//  SignInViewController.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {

    private let signInView = SignInView()
    private let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit {
        // MARK: - 키보드 알림 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        navigationItem.largeTitleDisplayMode = .inline

        bindView()
        bindViewModel()
        setObserver()
        setGesture()
    }

    // MARK: - Bind
    private func bindView() {
        signInView.emailTextField.rx.text.orEmpty
            .skip(1)
            .map { SignInViewModel.Action.userIDChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signInView.passwordTextField.rx.text.orEmpty
            .skip(1)
            .map { SignInViewModel.Action.passwordChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signInView.confirmPasswordTextField.rx.text.orEmpty
            .skip(1)
            .map { SignInViewModel.Action.confirmPasswordChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signInView.nicknameTextField.rx.text.orEmpty
            .skip(1)
            .map { SignInViewModel.Action.nicknameChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signInView.confirmButton.rx.tap
            .map { SignInViewModel.Action.didTapSignUpButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.isSignUpButtonEnabled
            .drive(signInView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)

        /// 아이디 유효성 검사 메시지 바인딩
        viewModel.state.userIDValidationMessage
            .drive(with: self) { owner, state in
                owner.signInView.configureEmailValidationLabel(text: state)
            }
            .disposed(by: disposeBag)

        /// 비밀번호 유효성 검사 메시지 바인딩
        viewModel.state.passwordValidationMessage
            .drive(with: self) { owner, state in
                owner.signInView.configurePasswordValidationLabel(text: state)
            }
            .disposed(by: disposeBag)

        /// 비밀번호 확인 유효성 검사 메시지 바인딩
        viewModel.state.confirmPasswordValidationMessage
            .drive(with: self) { owner, state in
                owner.signInView.configureConfirmPasswordValidationLabel(text: state)
            }
            .disposed(by: disposeBag)

        viewModel.state.route
            .emit(with: self) { owner, state in
                switch state {
                case .rootMain:
                    let alert = UIAlertController(title: "회원가입 성공", message: "로그인 성공 화면으로 이동합니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        let vc = DIContainer.shared.makeMainViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        self.replaceRootViewController(with: nav)
                    }))
                    self.present(alert, animated: true, completion: nil)

                case .showAlert(let message):
                    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Setting
    private func setObserver() {
        // MARK: - 키보드 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setGesture() {
        // 키보드 내리기 위한 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

}

// MARK: - Keyboard Handling
private extension SignInViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height

        UIView.animate(withDuration: duration) {
            self.signInView.scrollView.contentInset.bottom = keyboardHeight

            // iOS 13.0 이상에서만 verticalScrollIndicatorInsets 사용
            if #available(iOS 13.0, *) {
                self.signInView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            } else {
                self.signInView.scrollView.scrollIndicatorInsets.bottom = keyboardHeight
            }
        }

        // 현재 첫 번째 응답자(first responder)를 찾아 스크롤
        if let activeTextField = findActiveTextField(in: self.signInView) {
            let textFieldRectInScrollView = activeTextField.superview!.convert(activeTextField.frame, to: self.signInView.scrollView)
            self.signInView.scrollView.scrollRectToVisible(textFieldRectInScrollView, animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: duration) {
            self.signInView.scrollView.contentInset.bottom = 0

            // iOS 13.0 이상에서만 verticalScrollIndicatorInsets 사용
            if #available(iOS 13.0, *) {
                self.signInView.scrollView.verticalScrollIndicatorInsets.bottom = 0
            } else {
                self.signInView.scrollView.scrollIndicatorInsets.bottom = 0
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func findActiveTextField(in view: UIView) -> UITextField? {
        if let textField = view as? UITextField, textField.isFirstResponder {
            return textField
        }
        for subview in view.subviews {
            if let activeTextField = findActiveTextField(in: subview) {
                return activeTextField
            }
        }
        return nil
    }
}
