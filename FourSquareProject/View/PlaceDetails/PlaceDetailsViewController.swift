//
//  PlaceDetailsViewController.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class PlaceDetailsViewController: UIViewController {
    private let viewModel: PlaceDetailsViewModelProtocol
    private let router: RouterProtocol
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .white
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: PlaceDetailsViewModelProtocol,
         router: RouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
        setupBindings()
    }
}

// MARK: - Bindings
extension PlaceDetailsViewController {
    private func setupBindings() {
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        viewModel.place
            .do(onNext: { [weak self] place in
                guard let strongSelf = self else { return }
                guard let photo = place.photo?.photoURL,
                    let url = URL(string: photo) else { return }
                strongSelf.imageView.kf.setImage(with: url)
            })
            .map { $0.ratingText }
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension PlaceDetailsViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
    }
}

// MARK: - Layout
extension PlaceDetailsViewController {
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let superview = imageView.superview {
            imageView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}
