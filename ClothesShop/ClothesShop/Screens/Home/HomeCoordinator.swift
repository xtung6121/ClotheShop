//
//  HomeCoordinator.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//


import UIKit
import RxSwift
import RxCocoa

final class HomeCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() -> Observable<Void> {
        // 1. Initialize Home (Using a stub for now, or your real HomeVC)
        let viewController = UIViewController()
        viewController.title = "Home"
        viewController.view.backgroundColor = .systemBackground
        
        // Setup Tab Bar Item
        viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // 2. Add a temporary button to trigger navigation to Notifications
        let notifyButton = UIButton(type: .system)
        notifyButton.setTitle("Go to Notifications", for: .normal)
        viewController.view.addSubview(notifyButton)
        notifyButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        // 3. Reactive navigation logic
        notifyButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.showNotifications()
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        navigationController.setViewControllers([viewController], animated: false)
        return .never()
    }
    
    private func showNotifications() -> Observable<Void> {
        let viewModel = NotificationsViewModel()
        let viewController = NotificationsViewController(viewModel: viewModel)
        
        // Push the notifications screen
        navigationController.pushViewController(viewController, animated: true)
        
        return .just(())
    }
}
