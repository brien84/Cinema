//
//  OptionsViewController.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class OptionsViewController: UITableViewController {

    private let datasource: [City] = {
        return City.allCases.map { $0 }
    }()

    private lazy var headerView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: .headerHeight))
        label.textAlignment = .center
        label.textColor = .lightC
        label.font = .header
        label.text = "Pasirinkite miestą"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(OptionsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: .contentInset, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .darkC
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false

        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OptionsCell

        cell.title.text = datasource[indexPath.row].rawValue

        let selectedCity = UserDefaults.standard.readCity()
        cell.isSelected = selectedCity == datasource[indexPath.row] ? true : false

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.save(city: datasource[indexPath.row])
        NotificationCenter.default.post(name: .OptionsCityDidChange, object: nil)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension CGFloat {
    fileprivate static let headerHeight: CGFloat = .screenWidth * 0.25
    fileprivate static let contentInset: CGFloat = .screenHeight * 0.15
}

extension Notification.Name {
    static let OptionsCityDidChange = Notification.Name("OptionsCityDidChangeNotification")
}

extension UIFont {
    fileprivate static let header = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(23))
}
