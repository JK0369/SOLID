//
//  ButtonsViewController.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ButtonsViewController: UIViewController {

    static func create(with viewModel: ButtonsViewModel) -> ButtonsViewController {
        let viewController = ButtonsViewController(viewModel: viewModel)

        return viewController
    }

    private let disposeBag = DisposeBag()
    private var viewModel: ButtonsViewModel!

    init(viewModel: ButtonsViewModel) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8.0

        return view
    }()

    lazy var redButton: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor

        return button
    }()

    lazy var blueButton: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blue.cgColor

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        bindInput()
    }

    private func setupViews() {
        view.backgroundColor = .white
    }

    private func addSubviews() {
        view.addSubview(buttonStackView)
        [redButton, blueButton].forEach { buttonStackView.addArrangedSubview($0) }
    }

    private func makeConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }

    private func bindInput() {
        redButton.rx.tap.subscribe(onNext: { [weak self] in self?.viewModel.didTapRedButton() } ).disposed(by: disposeBag)
        blueButton.rx.tap.subscribe(onNext: { [weak self] in self?.viewModel.didTapBlueButton() } ).disposed(by: disposeBag)
    }

}
