//
//  BaseViewModel.swift
//  TruyenFull
//
//  Created by macmimi on 27/2/26.
//

import UIKit
import RxSwift

/// The base protocol defining the contract for reactive routing.
public protocol CoordinatorType: AnyObject {
    associatedtype CoordinationResult
    
    func start() -> Observable<CoordinationResult>
}

/// A generic base class that handles child coordinator memory management automatically.
open class BaseCoordinator<ResultType>: CoordinatorType {
    
    public typealias CoordinationResult = ResultType
    
    public let disposeBag = DisposeBag()
    
    /// A unique identifier for dictionary-based storage (O(1) insertion/removal).
    private let identifier = UUID()
    
    /// Stores child coordinators to retain them in memory while their flow is active.
    private var childCoordinators: [UUID: Any] = [:]
    
    public init() {}
    
    /// Must be overridden by subclasses to define the actual navigation logic.
    open func start() -> Observable<ResultType> {
        fatalError("start() must be implemented in the subclass.")
    }
    
    /// Coordinates to a child flow. It stores the child, subscribes to its flow,
    /// and automatically frees it from memory when the flow completes.
    public func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                // Automatically release the child coordinator when its job is done
                self?.free(coordinator)
            })
    }
    
    // MARK: - Memory Management
    
    private func store<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
}
