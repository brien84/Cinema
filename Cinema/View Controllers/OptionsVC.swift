//
//  OptionsVC.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class OptionsVC: UITableViewController {
    
    private let datasource: [City] = {
        return City.allCases.map { $0 }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "OptionsCell", bundle: nil), forCellReuseIdentifier: "optionsCell")
        tableView.rowHeight = 60
        
        // Sets default value, if the app is launched for the first time.
        if UserDefaults.standard.readCity() == nil {
            UserDefaults.standard.save(city: .vilnius)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsCell

        cell.title.text = datasource[indexPath.row].rawValue
        
        let selectedCity = UserDefaults.standard.readCity()
        cell.accessoryType = selectedCity == datasource[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.save(city: datasource[indexPath.row])
        NotificationCenter.default.post(name: .cityDidChange, object: nil)
        tableView.reloadData()
    }
}
