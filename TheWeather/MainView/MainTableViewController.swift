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

    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Current Weather"

        setupLoading()
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? WeatherTableViewCell else {
            fatalError("Dequeueing WeatherTableViewCell failed")
        }

        let data = viewModel.getCellViewModel(at: indexPath)

        cell.weather = data
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storybard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storybard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.viewModel = viewModel
            detailVC.indexPath = indexPath

            navigationController?.pushViewController(detailVC, animated: true)
        }

    }

    func setupLoading() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)

        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()

                    UIView.animate(withDuration: 0.5, animations: {
                        self?.view.alpha = 0.8
                    })
                } else {
                    self?.activityIndicator.stopAnimating()

                    UIView.animate(withDuration: 0.5, animations: {
                        self?.view.alpha = 1
                    })
                }
            }
        }
    }

}
