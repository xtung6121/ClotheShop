//
//  NotificationsViewModel.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

public protocol NotificationsViewModelInputs {
    /// Stream to trigger loading notifications
    var loadTrigger: AnyObserver<Void> { get }
}

public protocol NotificationsViewModelOutputs {
    var sections: Driver<[NotificationSection]> { get }
    var isLoading: Driver<Bool> { get }
    var error: Signal<String> { get }
}

public protocol NotificationsViewModelType {
    var inputs: NotificationsViewModelInputs { get }
    var outputs: NotificationsViewModelOutputs { get }
}

final class NotificationsViewModel: NotificationsViewModelType {
    
    // MARK: - Typealias
    var inputs: NotificationsViewModelInputs { self }
    var outputs: NotificationsViewModelOutputs { self }
    
    // MARK: - Private Subjects (Internal State)
    
    private let loadTriggerSubject = PublishSubject<Void>()
    private let sectionsSubject = BehaviorSubject<[NotificationSection]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    private let provider: MoyaProvider<EcommerceAPI>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<EcommerceAPI> = MoyaProvider<EcommerceAPI>()) {
        self.provider = provider
        bind()
    }
}

// MARK: - Inputs
extension NotificationsViewModel: NotificationsViewModelInputs {
    var loadTrigger: AnyObserver<Void> {
        loadTriggerSubject.asObserver()
    }
}

// MARK: - Outputs
extension NotificationsViewModel: NotificationsViewModelOutputs {

    var sections: Driver<[NotificationSection]> {
        sectionsSubject
            .asDriver(onErrorJustReturn: [])
    }

    var isLoading: Driver<Bool> {
        isLoadingRelay
            .asDriver()
    }

    var error: Signal<String> {
        errorRelay
            .asSignal()
    }
}

// MARK: - Binding Logic

private extension NotificationsViewModel {
    
    func bind() {
        
        loadTriggerSubject
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] _ -> Observable<[NotificationSection]> in
                
                guard let self = self else { return .just([]) }
                
                return self.provider.rx.request(.getNotifications)
                    .filterSuccessfulStatusCodes()
                    .map([NotificationSection].self)
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorRelay.accept(error.localizedDescription)
                        return .just([])
                    }
            }
            .subscribe(onNext: { [weak self] sections in
                self?.sectionsSubject.onNext(sections)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
