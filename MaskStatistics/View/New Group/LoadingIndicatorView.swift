//
//  LoadingIndicatorView.swift
//  Groutag
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        alpha = 0.0
    }
    
    func show() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1
        })
        loadingIndicatorView.startAnimating()
    }
 
    func hide() {
        loadingIndicatorView.stopAnimating()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: {  (_) in
            //self.removeFromSuperview()
        })
    }
}
