//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

protocol DateViewControllerDelegate: AnyObject {
    func dateVC(_ dateVC: DateViewController, didUpdateDatasource showings: [Showing])
}

final class DateViewController: UITableViewController {
    private let dateSelector: DateSelectable
    private let movieFetcher: MovieFetcher

    weak var delegate: DateViewControllerDelegate?

    private lazy var loadingView: NewLoadingView = {
        let view = NewLoadingView(frame: tableView.frame)
        tableView.addSubview(view)
        view.delegate = self
        return view
    }()

    private var datasource = [Showing]() {
        didSet {
            datasource.sort()

            delegate?.dateVC(self, didUpdateDatasource: datasource)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationObservers()

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

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        // Adjust `loadingView` height, since `loadingView` is initialized before `safeArea` is.
        loadingView.frame.size.height = tableView.frame.height - tableView.safeAreaInsets.top
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
        NotificationCenter.default.addObserver(forName: .DateSelectorDateDidChange, object: nil, queue: .main) { [self] _ in
            updateDatasource()
            navigationItem.leftBarButtonItem?.image = dateSelector.isFirst ? .options : .left
        }

        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { [self] _ in
            fetchMovies()
        }
    }

    private func fetchMovies() {
        prepareForFetching()
        loadingView.startLoading()

        movieFetcher.fetch { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success:
                    updateDatasource()
                case .failure(let error):
                    print(error)
                    loadingView.show(.noNetwork, animated: false)
                }
            }
        }
    }

    private func updateDatasource() {
        if loadingView.isHidden {
            hiddenLoadingViewTransition()
        } else {
            visibleLoadingViewTransition()
        }
    }

    // MARK: - Navigation

    private func toggleEnabled(scroll: Bool, buttons: Bool) {
        tableView.isScrollEnabled = scroll
        navigationItem.leftBarButtonItem?.isEnabled = buttons
        navigationItem.rightBarButtonItem?.isEnabled = dateSelector.isLast ? false : buttons
    }

    @IBAction private func leftNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        if dateSelector.isFirst {
            performSegue(withIdentifier: "openSettings", sender: nil)
        } else {
            dateSelector.previous()
        }
    }

    @IBAction private func rightNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        dateSelector.next()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedMovieCollectionVC" {
            guard let vc = segue.destination as? MoviesViewController else { return }
            delegate = vc
            transitionTableView?.transitionDelegate = vc
        }
    }
}

extension DateViewController: LoadingViewDelegate {
    func loadingView(_ view: NewLoadingView, retryButtonDidTap: UIButton) {
        fetchMovies()
    }
}

// MARK: - NavBar Transitions

extension DateViewController {
    private var navBarTitleView: UILabel {
        let label = UILabel()
        label.frame.size.height = navigationController?.navigationBar.frame.height ?? 0.0
        label.frame.size.width = (navigationController?.navigationBar.frame.width ?? 0.0) / 3
        label.textAlignment = .center
        label.textColor = .red

        return label
    }

    private func setNavBar(title: String?, animation direction: CATransitionSubtype?) {
        let titleView: UILabel

        if let label = navigationItem.titleView as? UILabel {
            titleView = label
        } else {
            titleView = navBarTitleView
            navigationItem.titleView = titleView
        }

        let transition = CATransition()
        transition.duration = .stdAnimation
        transition.type = .push
        transition.subtype = direction
        transition.timingFunction = .init(name: .easeInEaseOut)
        titleView.layer.add(transition, forKey: "transition")

        DispatchQueue.main.async {
            titleView.text = title
        }
    }
}

// MARK: - Table Transitions

extension DateViewController {
    private var transitionTableView: TransitionTableView? {
        tableView as? TransitionTableView
    }

    private func prepareForFetching() {
        toggleEnabled(scroll: false, buttons: false)
        transitionTableView?.scrollToTop()
        transitionTableView?.transitionDelegate?.prepareForTransition(animated: false, completion: nil)
        setNavBar(title: nil, animation: nil)
    }

    private func hiddenLoadingViewTransition() {
        toggleEnabled(scroll: false, buttons: false)

        transitionTableView?.prepareTransition { [self] in
            datasource = movieFetcher.getShowings(at: dateSelector.current)
            setNavBar(title: nil, animation: .fromLeft)

            transitionTableView?.beginTransition {
                setNavBar(title: dateSelector.current.asString(.monthAndDay), animation: .fromRight)

                if datasource.count > 0 {
                    transitionTableView?.endTransition {
                        toggleEnabled(scroll: true, buttons: true)
                    }
                } else {
                    loadingView.show(.noMovies, animated: true) {
                        toggleEnabled(scroll: false, buttons: true)
                    }
                }
            }
        }
    }

    private func visibleLoadingViewTransition() {
        toggleEnabled(scroll: false, buttons: false)

        let overlay = UIView(frame: tableView.bounds)
        overlay.backgroundColor = tableView.backgroundColor
        tableView.addSubview(overlay)

        datasource = movieFetcher.getShowings(at: dateSelector.current)
        setNavBar(title: nil, animation: .fromLeft)

        loadingView.hide { [self] in
            setNavBar(title: dateSelector.current.asString(.monthAndDay), animation: .fromRight)

            if datasource.count > 0 {
                overlay.removeFromSuperview()
                transitionTableView?.endTransition {
                    toggleEnabled(scroll: true, buttons: true)
                }
            } else {
                loadingView.show(.noMovies, animated: true) {
                    overlay.removeFromSuperview()
                    toggleEnabled(scroll: false, buttons: true)
                }
            }
        }
    }
}
