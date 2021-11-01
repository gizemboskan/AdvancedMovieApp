//
//  LoadingDisplayer.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 1.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

typealias ActivityHandler = ViewModel & RemoteLoading
typealias ActivityDisplayer = View  & LoadingDisplayer


protocol LoadingDisplayer {
    var isLoadingData: Binder<(isLoading: Bool, isEditable: Bool)> { get }
}

extension LoadingDisplayer where Self: UIViewController {
    var isLoadingData: Binder<(isLoading: Bool, isEditable: Bool)> {
        return Binder.init(self, binding: { (_, loadingData) in
            let isLoading = loadingData.isLoading
            if isLoading {
                self.startLoading()
            }else {
                self.stopLoading()
            }
        })
    }
}

protocol RemoteLoading {
    var isLoading: BehaviorRelay<Bool> { get }
    var isEditableLoading: Bool { get }
}

protocol ViewModel {}

protocol View: AnyObject {
    associatedtype VM: ViewModel
    var viewModel: VM { get }
    var bag: DisposeBag { get }
}

extension View where Self: LoadingDisplayer, Self.VM: RemoteLoading {
    func bindLoading() {
        viewModel.isLoading
            .asObservable()
            .map { [weak self] loading in (isLoading: loading, isEditable: (self?.viewModel.isEditableLoading).orFalse) }
            .observeOn(MainScheduler.instance)
            .bind(to: isLoadingData)
            .disposed(by: bag)
    }
}
