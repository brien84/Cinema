//
//  DateMovieVC.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DateMovieVC: UITableViewController {
    
    var datasource = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DateMovieCell", bundle: nil), forCellReuseIdentifier: "dateMovieCell")
        
        self.tableView.tableFooterView = UIView()
        tableView.rowHeight = 150
        tableView.backgroundColor = Constants.Colors.light
        tableView.separatorColor = Constants.Colors.blue
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateMovieCell", for: indexPath) as! DateMovieCell
        
        let movie = datasource[indexPath.row]
        
        cell.poster.url = movie.poster?.toURL()
        cell.title.text = movie.title
        cell.originalTitle.text = movie.originalTitle
        cell.duration.text = movie.duration
        cell.ageRating.text = movie.ageRating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieContainerVC()
        vc.movie = datasource[indexPath.row]
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
