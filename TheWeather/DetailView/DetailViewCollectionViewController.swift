//
//  DetailViewCollectionViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 9/8/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

private let headerCell = "headerCell"
private let detailCell = "detailCell"
private let weatherCell = "weatherCell"

let innerSpace: CGFloat = 5.0

class DetailViewCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var cityName: String?
    var indexPath: IndexPath?
    var viewModel: MainViewModel?
    fileprivate var detailWeather: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = viewModel {
            if let indexPath = indexPath,
                let data = viewModel.getAllWeatherInfo(at: indexPath) {
                detailWeather = data
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frame = collectionView.safeAreaLayoutGuide.layoutFrame

        if (indexPath.item == 0) {
            return CGSize(width: frame.size.width, height: 180)
        } else if (indexPath.item == 1) {
            return CGSize(width: frame.size.width, height: 120)
        } else {
            return CGSize(width: (frame.size.width-5)/2, height: 60)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return innerSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return innerSpace
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if (indexPath.item == 0) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCell, for: indexPath) as? HeaderCollectionViewCell else {
                fatalError("Dequeueing HeaderCell failed")
            }

            cell.backgroundColor = UIColor.cyan
            cell.weather = detailWeather

            return cell
        } else if (indexPath.item == 1) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCell, for: indexPath) as? DetailCollectionViewCell else {
                fatalError("Dequeueing DetailCell failed")
            }

            cell.backgroundColor = UIColor.yellow
            cell.weather = detailWeather
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCell, for: indexPath) as? WeatherCollectionViewCell else {
                fatalError("Dequeueing WeatherCell failed")
            }

            cell.backgroundColor = UIColor.brown
            if (indexPath.item == 2) {
                cell.type = WeatherType.wind
            } else if (indexPath.item == 3) {
                cell.type = WeatherType.humidity
            } else if (indexPath.item == 4) {
                cell.type = WeatherType.rain
            } else if (indexPath.item == 5) {
                cell.type = WeatherType.pressure
            }

            cell.weather = detailWeather

            return cell
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}
