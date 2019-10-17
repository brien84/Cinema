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

        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        tableView.rowHeight = 110
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        let movie = datasource[indexPath.row]
        
        cell.title.text = movie.title
        cell.originalTitle.text = movie.originalTitle
        cell.runtime.text = movie.duration
        cell.rating.text = movie.ageRating
        
        cell.poster.url = URL(string: movie.poster!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieContainerVC()
        vc.movie = datasource[indexPath.row]
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
