//
//  DailyViewController.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension DailyViewController: NavigationButtonDelegate {
    func tapped(_ sender: NavigationButton, _ gestureRecognizer: UITapGestureRecognizer) {
        
        if navigationItem.leftBarButtonItems?.contains(sender) ?? false {
            dateManager.decreaseDate()
        }
        
        if navigationItem.rightBarButtonItems?.contains(sender) ?? false {
            dateManager.increaseDate()
        }
        
        navigationItem.title = dateManager.selectedDate.asString()
        
        refresh()
    }
}

class DailyViewController: UITableViewController {
    
    private var movieDatasource = [Movie]()
    private var showingDatasource = [Showing]()
    
    private let dateManager = DateManager()
    private let movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ShowingCell", bundle: nil), forCellReuseIdentifier: "showingCell")

        if let button = navigationItem.leftBarButtonItem as? NavigationButton {
            button.delegate = self
        }
        
        if let button = navigationItem.rightBarButtonItem as? NavigationButton {
            button.delegate = self
        }
    }
    
    private func refresh() {
        showingDatasource = movieManager.getShowings(shownAt: dateManager.selectedDate)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingDatasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showingCell", for: indexPath) as! ShowingCell

        cell.title.text = showingDatasource[indexPath.row].date.asString()

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
