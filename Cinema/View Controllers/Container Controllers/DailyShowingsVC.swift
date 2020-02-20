//
//  DailyShowingsVC.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class DailyShowingsVC: UITableViewController {

    var datasource = [Showing]() {
        didSet {
            datasource.sort { $0.date < $1.date }
            tableView.reloadData()

            if !datasource.isEmpty {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DailyShowingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInset.top = .segmentedControlHeight
        tableView.backgroundColor = .darkC
        tableView.separatorColor = .grayC

        // Hides separator lines of empty cells, if there aren't enought items to fill visible screen.
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = datasource.count == 0 ? ErrorLabel(.noShowings) : nil
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DailyShowingsCell

        let showing = datasource[indexPath.row]

        cell.poster.url = showing.parentMovie?.poster
        cell.title.text = showing.parentMovie?.title
        cell.originalTitle.text = showing.parentMovie?.originalTitle
        cell.venue.text = showing.venue
        cell.time.text = showing.date.asString(format: .onlyTime)
        cell.screenType.text = showing.is3D ? "3D" : nil

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = datasource[indexPath.row].parentMovie else { return }
        let vc = MovieViewController(with: movie)
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
