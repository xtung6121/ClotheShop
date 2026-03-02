//
//  HomeViewController.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    // MARK: - Outlets
    // Add a label in your XIB and connect it here
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // MARK: - UI Setup
    override func setupUI() {
        super.setupUI()
        
        // Add a notification bell to the right side of the Nav Bar
        let bellButton = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.rightBarButtonItem = bellButton
        
        welcomeLabel?.text = "Loading..."
    }
    
    // MARK: - Binding
    override func bindViewModel() {
        super.bindViewModel()
    }
}
