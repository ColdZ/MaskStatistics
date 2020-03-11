//
//  LoadingIndicatorAbility.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

protocol LoadingIndicatorAbility: UIViewController{
    var loadingIndicator: LoadingIndicatorView? { get set }
    var isLoading: Bool { get set }
}

extension LoadingIndicatorAbility {
    func showLoadingIndicator() {
        guard !isLoading else { return }
        DispatchQueue.main.async {[weak self] in
            self?.showLoadingIndicator("")
        }
    }
    func showLoadingIndicator(_ description: String) {
        if loadingIndicator == nil{
           loadingIndicator = LoadingIndicatorView.loadFromXib()
            let centerPoint = CGPoint(x: view.center.x, y: (view.frame.size.height - view.frame.origin.y) / 2)
            loadingIndicator!.center = centerPoint
            view.addSubview(loadingIndicator!)
        }
        if description.count > 0 {
            loadingIndicator?.descriptionLabel.text = description
        }
        loadingIndicator?.show()
        isLoading = true
    }
    func hideLoadingIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.loadingIndicator?.hide()
            self?.isLoading = false
        }
    }
}

