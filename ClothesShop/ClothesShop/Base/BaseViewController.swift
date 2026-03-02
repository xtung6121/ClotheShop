//
//  BaseViewModel.swift
//  TruyenFull
//
//  Created by macmimi on 27/2/26.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController<ViewModelType>: UIViewController {
    
    // MARK: - Properties
    
    /// The strongly-typed ViewModel injected into the view controller.
    let viewModel: ViewModelType
    
    /// A shared DisposeBag for the view controller's reactive bindings.
    let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(viewModel:) instead.")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        bindViewModel()
    }
    
    deinit {
        // Helpful for tracking memory leaks during development
        #if DEBUG
        print("♻️ Deinit: \(String(describing: type(of: self)))")
        #endif
    }
    
    // MARK: - Open Methods (To be overridden)
    
    /// Override this method to configure the view hierarchy and styling.
    open func setupUI() {
        view.backgroundColor = .systemBackground
    }

    /// Override this method to bind the ViewModel's inputs and outputs.
    open func bindViewModel() {
        // Implementation in subclass
    }
}
