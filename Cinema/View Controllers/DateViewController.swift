//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol DateViewControllerDelegate: AnyObject {
    func dateVC(_ dateVC: DateViewController, didUpdate datasource: [Movie])
}

final class DateViewController: UITableViewController {
    private let dateSelector: DateSelectable

    private var movieFetcher: MovieFetcher
    weak var delegate: DateViewControllerDelegate?

    private var datasource = [Movie]() {
        didSet {
            delegate?.dateVC(self, didUpdate: datasource)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateNavigationItemAppearance()
        tableView.tableHeaderView?.frame.size = moviesContainerSize

        // swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { _ in
            self.fetchMovies()
        }

        fetchMovies()
    }

    init(dateSelector: DateSelectable, movieFetcher: MovieFetcher) {
        self.dateSelector = dateSelector
        self.movieFetcher = movieFetcher

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.dateSelector = DateSelector()
        self.movieFetcher = MovieFetcher()

        super.init(coder: coder)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "showingCell", for: indexPath) as! DateShowingCell

        return cell
    }

    private func fetchMovies() {
        let city = UserDefaults.standard.readCity()

        movieFetcher.fetchMovies(in: city) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.datasource = movies
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction private func leftNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        if dateSelector.isFirst {
            performSegue(withIdentifier: "openSettings", sender: nil)
        } else {
            dateSelector.previous()
            updateNavigationItemAppearance()
        }
    }

    @IBAction private func rightNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        dateSelector.next()
        updateNavigationItemAppearance()
    }

    private func updateNavigationItemAppearance() {
        navigationItem.title = dateSelector.current.asString(format: .monthAndDay)

        guard let leftButton = navigationItem.leftBarButtonItem else { return }
        leftButton.image = dateSelector.isFirst ? .options : .left
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedMovieCollectionVC" {
            guard let vc = segue.destination as? MoviesViewController else { return }
            delegate = vc
        }
    }
}

extension DateViewController {
    private var moviesContainerSize: CGSize {
        let tableWidth = tableView.frame.width
        return CGSize(width: tableWidth, height: tableWidth * 1.2)
    }
}
