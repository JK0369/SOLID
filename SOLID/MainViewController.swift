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

    lazy var lspButton: UIButton = {
        let button = UIButton()
        button.setTitle("LSP", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    lazy var dipButton: UIButton = {
        let button = UIButton()
        button.setTitle("DIP", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    lazy var coordinatorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Coordinator", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    lazy var networkButton: UIButton = {
        let button = UIButton()
        button.setTitle("network", for: .normal)
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
        [ocpButton, lspButton, dipButton, coordinatorButton, networkButton].forEach { buttonContainerStackView.addArrangedSubview($0) }
    }

    private func makeConstraints() {
        buttonContainerStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }

    private func bindEvents() {
        ocpButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapOcpButton() }).disposed(by: disposeBag)
        lspButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapLspButton() }).disposed(by: disposeBag)
        dipButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapDipButton() }).disposed(by: disposeBag)
        coordinatorButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapcoordinatorButton() }).disposed(by: disposeBag)
        networkButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapNetworkButton() }).disposed(by: disposeBag)
    }

    private func didTapOcpButton() {
        /// DI
        let keychainRepositoryImpl = KeychainRepositoryImpl.shared
        let keychainServiceImpl = KeychainServiceImpl(keychainRepository: keychainRepositoryImpl)
        let colorUseCaseImpl = ColorUseCaseImpl(keychainService: keychainServiceImpl)
        let viewModel = ColorViewModelImpl(colorUseCase: colorUseCaseImpl)

        navigationController?.pushViewController(ColorViewController(viewModel: viewModel), animated: true)
    }

    private func didTapLspButton() {
        // DI
        let randomInt = Int.random(in: (0...1))
        let useCase: LicenseUseCase
        if randomInt == 0 {
            useCase = PersonalUseCase()
        } else {
            useCase = BusinessUseCase()
        }
        let viewModel = BillingViewModelImpl(licenseUseCase: useCase)
        let viewController = BillingViewController(viewModel: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func didTapDipButton() {
        let productListDIContainer = ProductListDIContainer()
        let viewController = productListDIContainer.productListViewController

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func didTapcoordinatorButton() {
        let buttonsDIContainer = ButtonsDIContainer()
        let coordinator = buttonsDIContainer.makeButtonCoordinator(navigationController: navigationController!)

        coordinator.start()
    }

    private func didTapNetworkButton() {

        // TODO: dataTransferService객체는 AppDIContainer를 만들어서, CitySceneDIContainer의 생성자에 주입
        let baseURL = URL(string: "https://projects.propublica.org/")! // baseURL같은 정보는 info.plist같은곳에 정의
        let networkService = DefaultNetworkService(config: ApiDataNetworkConfig(baseURL: baseURL))
        let dataTransferService = DefaultDataTransferService(with: networkService)

        let cityDIContainer = CitySceneDIContainer(dependencies: .init(cityDataTransferService: dataTransferService))
        let cityCoordinator = CitySceneCoordinator(navigationController: navigationController!, dependencies: cityDIContainer)

        cityCoordinator.start()
    }
}
