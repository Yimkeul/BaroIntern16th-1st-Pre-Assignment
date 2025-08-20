//
//  SignInView.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit
import SnapKit
import Then

final class SignInView: UIView {

    // MARK: - UI Components
    private let _scrollView = UIScrollView()
    private let _contentView = UIView() 

    private let _emailLabel = UILabel()
    private let _emailField = UITextField()
    private let _emailValidationLabel = UILabel()

    private let _passwordLabel = UILabel()
    private let _passwordField = UITextField()
    private let _passwordValidationLabel = UILabel()

    private let _confirmPasswordLabel = UILabel()
    private let _confirmPasswordField = UITextField()
    private let _confirmPasswordValidationLabel = UILabel()

    private let _nicknameLabel = UILabel()
    private let _nicknameField = UITextField()

    private let _stack = UIStackView()
    private let _confirmButton = UIButton(type: .system)

    var scrollView: UIScrollView { _scrollView }
    var confirmButton: UIButton { _confirmButton }
    var emailTextField: UITextField { _emailField }
    var passwordTextField: UITextField { _passwordField }
    var confirmPasswordTextField: UITextField { _confirmPasswordField }
    var nicknameTextField: UITextField { _nicknameField }
    var emailValidationLabel: UILabel { _emailValidationLabel }
    var passwordValidationLabel: UILabel { _passwordValidationLabel }
    var confirmPasswordValidationLabel: UILabel { _confirmPasswordValidationLabel }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public Method
    func configureEmailValidationLabel(text: String?) {
        emailValidationLabel.text = text
        emailValidationLabel.textColor = (text != nil) ? .cRed : .clear
    }

    func configurePasswordValidationLabel(text: String?) {
        passwordValidationLabel.text = text
        passwordValidationLabel.textColor = (text != nil) ? .cRed : .clear
    }

    func configureConfirmPasswordValidationLabel(text: String?) {
        confirmPasswordValidationLabel.text = text
        confirmPasswordValidationLabel.textColor = (text != nil) ? .cRed : .clear
    }
}

// MARK: - Setup
private extension SignInView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .systemBackground

        // 스크롤 뷰 설정
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.keyboardDismissMode = .interactive // 키보드 드래그로 내리기 가능

        // 레이블 속성 설정
        [_emailLabel, _passwordLabel, _confirmPasswordLabel, _nicknameLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = .label
        }
        _emailLabel.text = "아이디"
        _passwordLabel.text = "비밀번호"
        _confirmPasswordLabel.text = "비밀번호 확인"
        _nicknameLabel.text = "닉네임"

        // 유효성 검사 메시지 레이블 속성 설정
        [_emailValidationLabel, _passwordValidationLabel, _confirmPasswordValidationLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.textColor = .cRed
            $0.numberOfLines = 0
        }

        [_emailField, _passwordField, _confirmPasswordField, _nicknameField].forEach {
            $0.backgroundColor = .secondarySystemBackground
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
            $0.clearButtonMode = .whileEditing
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
            $0.leftViewMode = .always
            $0.heightAnchor.constraint(equalToConstant: 52).isActive = true
        }

        _emailField.do {
            $0.placeholder = "이메일"
            $0.keyboardType = .emailAddress
            $0.textContentType = .username
        }

        _passwordField.do {
            $0.placeholder = "비밀번호 (최소 8자)"
            $0.isSecureTextEntry = true
            $0.textContentType = .newPassword
            $0.returnKeyType = .next
        }

        _confirmPasswordField.do {
            $0.placeholder = "비밀번호 확인"
            $0.isSecureTextEntry = true
            $0.textContentType = .newPassword
            $0.returnKeyType = .next
        }

        _nicknameField.do {
            $0.placeholder = "닉네임"
            $0.keyboardType = .default
            $0.textContentType = .nickname
            $0.returnKeyType = .done
        }

        _stack.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }

        _confirmButton.do {
            var config = UIButton.Configuration.filled()
            config.title = "회원가입"
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .cRed
            config.cornerStyle = .large
            $0.configuration = config
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true

            $0.configurationUpdateHandler = { btn in
                guard var cfg = btn.configuration else { return }
                if !btn.isEnabled {
                    cfg.baseBackgroundColor = .systemGray4
                    cfg.baseForegroundColor = .white
                } else if btn.isHighlighted {
                    cfg.baseBackgroundColor = .darkGray
                    cfg.baseForegroundColor = .white
                } else {
                    cfg.baseBackgroundColor = .cRed
                    cfg.baseForegroundColor = .white
                }
                btn.configuration = cfg
            }
        }
    }

    func setHierarchy() {
        // 스크롤 뷰와 버튼을 최상위 뷰에 추가
        addSubviews(_scrollView, _confirmButton)
        _scrollView.addSubview(_contentView)
        _contentView.addSubview(_stack)

        // 각 섹션을 별도의 스택뷰로 묶기
        let emailStack = createSectionStack(label: _emailLabel, field: _emailField, validationLabel: _emailValidationLabel)
        let passwordStack = createSectionStack(label: _passwordLabel, field: _passwordField, validationLabel: _passwordValidationLabel)
        let confirmPasswordStack = createSectionStack(label: _confirmPasswordLabel, field: _confirmPasswordField, validationLabel: _confirmPasswordValidationLabel)
        let nicknameStack = createSectionStack(label: _nicknameLabel, field: _nicknameField, validationLabel: nil)

        // 메인 스택뷰에 섹션 스택뷰들 추가
        _stack.addArrangedSubviews(emailStack, passwordStack, confirmPasswordStack, nicknameStack)

        // 메인 스택뷰에 섹션 간 간격 설정
        _stack.setCustomSpacing(20, after: emailStack)
        _stack.setCustomSpacing(20, after: passwordStack)
        _stack.setCustomSpacing(20, after: confirmPasswordStack)
    }

    func setConstraints() {
        _confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(56)
        }

        _scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(_confirmButton.snp.top).offset(-12)
        }

        _contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalToSuperview()
        }

        _stack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }

    private func createSectionStack(label: UILabel, field: UITextField, validationLabel: UILabel?) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, field])
        stack.axis = .vertical
        stack.spacing = 8

        if let validationLabel = validationLabel {
            stack.addArrangedSubview(validationLabel)
            validationLabel.snp.makeConstraints {
                $0.height.equalTo(18)
            }
        }

        return stack
    }
}
