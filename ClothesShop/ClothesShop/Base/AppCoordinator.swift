//
//  AppCoordinator.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let tabBarController = UITabBarController()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() -> Observable<Void> {
        // Home Flow (Real Navigation logic)
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        
        // Other Flows (Stubs)
        let searchNav = createTabNav(title: "Search", icon: "magnifyingglass")
        let searchCoordinator = StubCoordinator(navigationController: searchNav, title: "Search")
        
        let savedNav = createTabNav(title: "Saved", icon: "heart")
        let savedCoordinator = StubCoordinator(navigationController: savedNav, title: "Saved")
        
        let cartNav = createTabNav(title: "Cart", icon: "cart")
        let cartCoordinator = StubCoordinator(navigationController: cartNav, title: "Cart")
        
        let accountNav = createTabNav(title: "Account", icon: "person")
        let accountCoordinator = StubCoordinator(navigationController: accountNav, title: "Account")
        
        tabBarController.viewControllers = [homeNav, searchNav, savedNav, cartNav, accountNav]
        configureTabBarAppearance()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return Observable.merge([
            coordinate(to: homeCoordinator),
            coordinate(to: searchCoordinator),
            coordinate(to: savedCoordinator),
            coordinate(to: cartCoordinator),
            coordinate(to: accountCoordinator)
        ])
    }
    
    // Helper to setup NavControllers with TabBarItems
    private func createTabNav(title: String, icon: String) -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), selectedImage: UIImage(systemName: "\(icon).fill"))
        return nav
    }
    
    private func configureTabBarAppearance() {
        // This makes the active icon and text black
        tabBarController.tabBar.tintColor = .black
        
        // This makes the inactive icons a subtle gray
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
        
        tabBarController.tabBar.backgroundColor = .systemBackground
    }
}

/// A placeholder coordinator to stub out feature modules during development.
final class StubCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    private let title: String
    
    init(navigationController: UINavigationController, title: String) {
        self.navigationController = navigationController
        self.title = title
        super.init()
    }
    
    override func start() -> Observable<Void> {
        // 1. Create a dummy ViewController
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        viewController.title = title
        
        // 2. Add a centered label to identify the screen
        let label = UILabel()
        label.text = "\(title) Module (Stub)"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        // 3. Set the Root of this tab's Navigation stack
        navigationController.setViewControllers([viewController], animated: false)
        
        // We return .never() because a Tab root usually doesn't "finish"
        // until the app closes or the user logs out.
        return .never()
    }
}
