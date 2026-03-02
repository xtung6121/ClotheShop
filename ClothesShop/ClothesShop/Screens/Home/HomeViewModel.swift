//
//  HomeViewController.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let loadTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let title: Driver<String>
        let isLoading: Driver<Bool>
    }
    
    // MARK: - Protocol Conformance
    let input: Input
    let output: Output
    
    init() {
        let input = Input()
        self.input = input
        
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        
        // Stubbing a title that updates after a "load"
        let title = input.loadTrigger
            .do(onNext: { _ in isLoadingRelay.accept(true) })
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in "Shopee Mall" }
            .do(onNext: { _ in isLoadingRelay.accept(false) })
            .asDriver(onErrorJustReturn: "Home")
        
        self.output = Output(
            title: title,
            isLoading: isLoadingRelay.asDriver()
        )
    }
}
