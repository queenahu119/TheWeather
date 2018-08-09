//
//  AddCityTableViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 7/8/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit
import CRRefresh

class AddCityTableViewController: UITableViewController {

    private let reuseIdentifier = "CityCellId"

    lazy var viewModel: AddCityViewModel = {
        return AddCityViewModel()
    }()

    var activityIndicator:UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.initFetch()

        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        setupLoading()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.loadMoreData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.cr.endLoadingMore()
                self?.tableView.cr.noticeNoMoreData()
                self?.tableView.cr.resetNoMore()
            })
        }
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
            fatalError("Dequeueing WeatherTableViewCell failed")
        }

        if let data: City? = viewModel.getCellViewModel(at: indexPath) {
            cell.textLabel?.text = data?.name
        }

        return cell
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

    // MARK: - Private instance methods

    func filterContentForSearchText(_ searchText: String) {

        viewModel.updateSearchResults(text: searchText)
    }

    func isFiltering() -> Bool {
        let searchBarIsEmpty = searchController.searchBar.text?.isEmpty ?? true
        return searchController.isActive && (!searchBarIsEmpty)
    }

    func loadMoreData() {

        if !isFiltering() {
            let currentCount = viewModel.numberOfCells

            viewModel.appendData(start: currentCount, count: 15)
        }
    }

}

// MARK: - UISearchResultsUpdating Delegate
extension AddCityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearch = isFiltering()

        filterContentForSearchText(searchController.searchBar.text!)
    }
}
