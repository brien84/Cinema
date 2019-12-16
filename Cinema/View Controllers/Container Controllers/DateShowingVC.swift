//
//  DateShowingVC.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class DateShowingVC: UITableViewController {
    
    var datasource = [Showing]() {
        didSet {
            self.datasource.sort { $0.date < $1.date }
            tableView.setBackground(self.datasource.isEmpty, error: .noShowings)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DateContainerCell.self, forCellReuseIdentifier: "dateContainerCell")
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 150
        tableView.backgroundColor = Constants.Colors.light
        tableView.separatorColor = Constants.Colors.blue
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateContainerCell", for: indexPath) as! DateContainerCell
        
        let showing = datasource[indexPath.row]
        
        cell.poster.url = showing.parentMovie?.poster?.toURL()
        cell.title.text = showing.parentMovie?.title
        cell.originalTitle.text = showing.parentMovie?.originalTitle
        cell.leftLabel.text = showing.venue
        cell.rightLabel.text = showing.date.asString(format: .onlyTime)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieContainerVC()
        guard let movie = datasource[indexPath.row].parentMovie else { return }
        vc.movie = movie
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
