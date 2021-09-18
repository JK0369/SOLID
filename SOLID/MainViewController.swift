//
//  MainViewController.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/18.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {

    lazy var buttonContainerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16.0

        return view
    }()

    lazy var ocpButton: UIButton = {
        let button = UIButton()
        button.setTitle("OCP", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        bindEvents()
    }

    private func setupViews() {
        view.backgroundColor = .white
    }

    private func addSubviews() {
        view.addSubview(buttonContainerStackView)
        [ocpButton].forEach { buttonContainerStackView.addArrangedSubview($0) }
    }

    private func makeConstraints() {
        buttonContainerStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }

    private func bindEvents() {
        ocpButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapOcpButton() }).disposed(by: disposeBag)
    }

    private func didTapOcpButton() {
        /// DI
        let keychainRepositoryImpl = KeychainRepositoryImpl.shared
        let keychainServiceImpl = KeychainServiceImpl(keychainRepository: keychainRepositoryImpl)
        let colorUseCaseImpl = ColorUseCaseImpl(keychainService: keychainServiceImpl)
        let viewModel = ColorViewModelImpl(colorUseCase: colorUseCaseImpl)

        navigationController?.pushViewController(ColorViewController(viewModel: viewModel), animated: true)
    }
}
