//
//  MovieTableVC.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieTableVC: UITableViewController {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Movie VC APP")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Movie VC DIS")
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
        cell.runtime.text = movie.runtime
        cell.rating.text = movie.rated
        
        return cell
    }
}
