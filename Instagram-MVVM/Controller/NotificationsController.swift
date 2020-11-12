//
//  NotificationsController.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 10/23/20.
//

import UIKit

class NotificationsController: UITableViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    //MARK: - Helpers
    
    private func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
}

//MARK: - UITableViewDataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        return cell
    }
}

