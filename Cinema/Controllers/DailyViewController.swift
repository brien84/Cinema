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
            manager.decreaseDate()
        }
        
        if navigationItem.rightBarButtonItems?.contains(sender) ?? false {
            manager.increaseDate()
        }
        
        navigationItem.title = manager.selectedDate.asString()
    }
}

class DailyViewController: UITableViewController {
    
    let manager = DateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let button = navigationItem.leftBarButtonItem as? NavigationButton {
            button.delegate = self
        }
        
        if let button = navigationItem.rightBarButtonItem as? NavigationButton {
            button.delegate = self
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
