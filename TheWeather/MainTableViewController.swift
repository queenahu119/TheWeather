//
//  MainTableViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    private let reuseIdentifier = "CellId"

    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.initFetch()

        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UITableViewCell else {
            fatalError("Dequeueing UITableViewCell failed")
        }

        let data = viewModel.getCellViewModel(at: indexPath)

        cell.textLabel?.text = data?.cityText
        return cell
    }

}
