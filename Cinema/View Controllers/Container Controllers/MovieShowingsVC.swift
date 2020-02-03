//
//  MovieShowingsVC.swift
//  Cinema
//
//  Created by Marius on 29/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class MovieShowingsVC: UITableViewController {
    
    var datasource = [Showing]() {
        didSet {
            datasource.sort { $0.date < $1.date }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MovieShowingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: .segmentedControlHeight, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = Colors.dark
        tableView.separatorColor = Colors.gray
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieShowingsCell
        
        let showing = datasource[indexPath.row]
        
        cell.date.text = showing.date.asString(format: .monthNameAndDay)
        cell.time.text = showing.date.asString(format: .onlyTime)
        cell.venue.text = showing.venue
        cell.screenType.text = showing.is3D ? "3D" : nil
        
        return cell
    }
}
