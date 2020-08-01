//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DateViewController: UITableViewController {
    private let datasource = Array(0...100)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView?.frame.size = moviesContainerSize
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = String(datasource[indexPath.row])

        return cell
    }
}

extension DateViewController {
    private var moviesContainerSize: CGSize {
        let tableWidth = tableView.frame.width
        return CGSize(width: tableWidth, height: tableWidth / 1.5)
    }
}
