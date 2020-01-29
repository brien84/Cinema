//
//  OptionsViewController.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum City: String, CaseIterable {
    case vilnius = "Vilnius"
    case kaunas = "Kaunas"
    case klaipeda = "Klaipėda"
    case siauliai = "Šiauliai"
}

private let reuseIdentifier = "Cell"

///
final class OptionsViewController: UITableViewController {
    
    private let datasource: [City] = {
        return City.allCases.map { $0 }
    }()
    
    private let headerView: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleHeight]
        label.frame = label.frame.inset(by: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.DateContainerCell.title
        label.text = "Pasirinkite miestą"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(OptionsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = Constants.Colors.light
        tableView.separatorColor = Constants.Colors.blue
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
        self.navigationController?.popViewController(animated: true)
    }
}

extension Notification.Name {
    static let OptionsCityDidChange = Notification.Name("OptionsCityDidChangeNotification")
}
