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
        tableView.rowHeight = 110
    }
    
    private func readUserDefaults() -> City? {
        if let city = UserDefaults.standard.string(forKey: "city") {
            return City(rawValue: city)
        } else {
            return nil
        }
    }
    
    private func saveUserDefaults(city: City) {
        UserDefaults.standard.set(city.rawValue, forKey: "city")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsCell

        let selectedCity = readUserDefaults()
        
        cell.title.text = datasource[indexPath.row].rawValue
        
        cell.accessoryType = selectedCity == datasource[indexPath.row] ? .checkmark : .none
        
        //cell.accessoryType = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        saveUserDefaults(city: datasource[indexPath.row])
        tableView.reloadData()
        
    }
}
