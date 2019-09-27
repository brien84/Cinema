//
//  ShowingTableVC.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ShowingTableVC: UITableViewController {
    var datasource = [Showing]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ShowingCell", bundle: nil), forCellReuseIdentifier: "showingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Showing VC APP")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Showing VC DIS")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showingCell", for: indexPath) as! ShowingCell
        
        let showing = datasource[indexPath.row]
        
        cell.title.text = showing.parentMovie.title
        cell.originalTitle.text = showing.parentMovie.originalTitle
        cell.venue.text = showing.venue
        cell.time.text = showing.date.asString()
        
        return cell
    }
}
