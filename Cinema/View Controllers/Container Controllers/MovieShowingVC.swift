//
//  MovieShowingVC.swift
//  Cinema
//
//  Created by Marius on 29/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieShowingVC: UITableViewController {
    
    var datasource = [Showing]() {
        didSet {
            self.datasource.sort { $0.date < $1.date }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieShowingCell", bundle: nil), forCellReuseIdentifier: "movieShowingCell")
        
        self.tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        tableView.backgroundColor = Constants.Colors.light
        tableView.separatorColor = Constants.Colors.blue
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieShowingCell", for: indexPath) as! MovieShowingCell
        
        let showing = datasource[indexPath.row]
        
        cell.venue.text = showing.venue
        cell.date.text = showing.date.asString(format: .monthNameAndDay)
        cell.time.text = showing.date.asString(format: .onlyTime)
        
        return cell
    }
}
