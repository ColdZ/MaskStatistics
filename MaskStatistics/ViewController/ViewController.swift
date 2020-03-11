//
//  ViewController.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData({ _ in})
    }
}

