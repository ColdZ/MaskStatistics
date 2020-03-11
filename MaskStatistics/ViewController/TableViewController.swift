//
//  TableViewController.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, LoadingIndicatorAbility {
    var loadingIndicator: LoadingIndicatorView?
    var isLoading: Bool = false
    
    lazy var viewModel: ViewModel = {
        let viewModel = ViewModel()
        bindingViewModel(viewModel)
        return viewModel
    }()
    
    var dataArray: [Feature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        viewModel.service.fetchData()
        showLoadingIndicator()
    }

    private func initLayout() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        if let height = refreshControl?.frame.size.height {
            tableView.contentOffset = CGPoint(x: 0, y: -height)
        }
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 43.5
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindingViewModel(_ viewModel: ViewModel) {
        viewModel.updatedDataArray = {[weak self] (countyMaskCountArray) in
            guard let strongSelf = self else { return }
            strongSelf.dataArray = countyMaskCountArray
            strongSelf.tableView.reloadData()
            strongSelf.navigationItem.title = "各縣市成人口罩統計列表@\(Date().toString())"
            strongSelf.hideLoadingIndicator()
        }
    }
    
    @objc private func headerRefresh() {
        if let isRefreshing = refreshControl?.isRefreshing,
            isRefreshing {
            refreshControl?.endRefreshing()
        }
        viewModel.service.fetchData()
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
