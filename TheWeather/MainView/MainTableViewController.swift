//
//  MainTableViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, AddCityTableViewControllerDelegate {
    private let reuseIdentifier = "CellId"

    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()

    private var activityIndicator:UIActivityIndicatorView!
    private var timer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Current Weather"

        self.setupNavBarButtons()

        setupLoading()
        viewModel.initFetch()

        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        startUpdateWeatherTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        self.stopUpdateWeatherTimer()
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

        // DetailViewController
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storybard.instantiateViewController(withIdentifier: "DetailViewCollectionViewController") as? DetailViewCollectionViewController {
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

    private func setupNavBarButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(onAddList))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                         target: self, action: #selector(onAddList))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
    }

    func startUpdateWeatherTimer() {
        let queue = DispatchQueue(label: "update.current.weather")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(60))
        timer!.setEventHandler { [weak self] in
            self?.viewModel.fetchData()
        }
        timer!.resume()
    }

    func stopUpdateWeatherTimer() {
        timer?.cancel()
        timer = nil
    }

    // MARK: - Action
    @objc func onAddList() {
        performSegue(withIdentifier: "ToAddCityView", sender: self)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddCityView" {
            if let destination : AddCityTableViewController = segue.destination as? AddCityTableViewController {
                destination.delegate = self
            }
        }
    }

    func addNewCityCompletion(_ city: City) {
        viewModel.addCity(id: city.id)
    }
}
