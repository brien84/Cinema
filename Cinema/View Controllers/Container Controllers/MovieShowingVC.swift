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
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ShowingCell", bundle: nil), forCellReuseIdentifier: "showingCell")
        tableView.rowHeight = 110
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showingCell", for: indexPath) as! ShowingCell
        
        let showing = datasource[indexPath.row]
        
        //cell.title.text = showing.parentMovie.title
        //cell.originalTitle.text = showing.parentMovie.originalTitle
        cell.venue.text = showing.venue
        cell.time.text = showing.date.asString()
        
        return cell
    }
}
