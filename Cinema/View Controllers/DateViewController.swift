//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol DateViewControllerDelegate: AnyObject {
    func dateVC(_ dateVC: DateViewController, didUpdateDatasource movies: [Movie])
}

final class DateViewController: UITableViewController {
    private let dateSelector: DateSelectable
    private let movieFetcher: MovieFetcher

    weak var delegate: DateViewControllerDelegate?

    private var datasource = [Showing]() {
        didSet {
            delegate?.dateVC(self, didUpdateDatasource: movieFetcher.getMovies(at: dateSelector.current))

            if datasource.count > 0 {
                datasource = sorted(datasource)
                scrollToTop()

                tableView.tableHeaderView?.isHidden = false
                loadingView.isHidden = true
            } else {
                tableView.tableHeaderView?.isHidden = true
                loadingView.display(error: .noMovies)
            }

            tableView.reloadData()
        }
    }

    private lazy var loadingView: NewLoadingView = {
        let view = NewLoadingView()
        tableView.backgroundView = view
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationObservers()
        updateNavigationItemAppearance()

        tableView.tableHeaderView?.frame.size = moviesContainerSize

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

        let showing = datasource[indexPath.row]

        cell.poster.url = showing.parentMovie?.poster
        cell.title.text = showing.parentMovie?.title
        cell.originalTitle.text = showing.parentMovie?.originalTitle
        cell.venue.text = showing.venue
        cell.time.text = showing.date.asString(.timeOfDay)
        cell.is3D = showing.is3D

        return cell
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .DateSelectorDateDidChange, object: nil, queue: .main) { _ in
            self.updateDatasource()
        }

        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { _ in
            self.fetchMovies()
        }
    }

    private func updateDatasource() {
        let date = self.dateSelector.current
        self.datasource = self.movieFetcher.getShowings(at: date)
    }

    private func fetchMovies() {
        datasource.removeAll()
        loadingView.startLoading()

        movieFetcher.fetch { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateDatasource()
                case .failure(let error):
                    print(error)
                    self.loadingView.display(error: .noNetwork)
                }
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
        navigationItem.title = dateSelector.current.asString(.monthAndDay)

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
    /// Returns `[Showings]` sorted in ascending order by `date` with`parentMovie.title` and `venue` tie-breaks.
    private func sorted(_ datasource: [Showing]) -> [Showing] {
        datasource.sorted {
            if $0.date != $1.date {
                return $0.date < $1.date
            } else {
                guard let title0 = $0.parentMovie?.title else { return false }
                guard let title1 = $1.parentMovie?.title else { return true }

                if title0 != title1 {
                    return title0 < title1
                } else {
                    return $0.venue < $1.venue
                }
            }
        }
    }

    /// Scrolls to the top of `tableView`.
    private func scrollToTop() {
        if tableView.contentOffset.y > 0 {
            if let navBar = navigationController?.navigationBar {
                // Height of status bar + navigation bar.
                let unsafeAreaHeight = navBar.frame.maxY
                tableView.setContentOffset(CGPoint(x: 0, y: -unsafeAreaHeight), animated: false)
                tableView.layoutIfNeeded()
            }
        }
    }
}

extension DateViewController: LoadingViewDelegate {
    func loadingView(_ view: NewLoadingView, retryButtonDidTap: UIButton) {
        fetchMovies()
    }
}

extension DateViewController {
    private var moviesContainerSize: CGSize {
        let tableWidth = tableView.frame.width
        return CGSize(width: tableWidth, height: tableWidth * 1.2)
    }
}
