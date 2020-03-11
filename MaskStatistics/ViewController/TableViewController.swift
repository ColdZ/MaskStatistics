//
//  TableViewController.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    lazy var viewModel: ViewModel = {
        let viewModel = ViewModel()
        bindingViewModel(viewModel)
        return viewModel
    }()
    
    var dataArray: [Feature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData({ _ in})
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func bindingViewModel(_ viewModel: ViewModel) {
        viewModel.updatedDataArray = {[weak self] (countyMaskCountArray) in
            guard let strongSelf = self else { return }
            strongSelf.dataArray = countyMaskCountArray
            strongSelf.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source
extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if indexPath.row < dataArray.count {
            let feature = dataArray[indexPath.row]
            cell.countyLabel.text = feature.countyName
            cell.maskCountLabel.text = String(feature.adultMaskCount)
        }
        
        return cell
    }
}
