//
//  BaseViewModel.swift
//  TruyenFull
//
//  Created by macmimi on 27/2/26.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
