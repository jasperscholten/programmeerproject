//
//  NewsAdminVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  In this ViewController, a user can see all the newsItems of his own location (where he is employed). Selecting one of them segues to the next ViewController, which will show the newsItem. If the user is an admin, he also gets the option to create a new item.

import UIKit
import Firebase

class NewsAdminVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants and variables
    let newsRef = FIRDatabase.database().reference(withPath: "News")
    var admin = Bool()
    var organisationID = String()
    var location = String()
    var newsItems = [News]()
    
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Only allow admin users to create new newsitems. [1]
        if admin == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Retrieve newsitems for current location from Firebase.
        newsRef.observe(.value, with: { snapshot in
            var newItems: [News] = []
            
            for item in snapshot.children {
                let newsData = News(snapshot: item as! FIRDataSnapshot)
                if newsData.organisation == self.organisationID && newsData.location == self.location {
                    newItems.append(newsData)
                }
            }
            self.newsItems = newItems
            self.newsTableView.reloadData()
        })
        
    }

    // MARK: - Tableview Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsItemAdmin", for: indexPath) as! NewsItemAdminCell
        cell.title.text = newsItems[indexPath.row].title
        cell.date.text = newsItems[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNewsItem", sender: self)
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Segue details needed to create new item, or details of selected newsItem.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let news = segue.destination as? NewsItemAdminVC {
            let indexPath = newsTableView.indexPathForSelectedRow
            news.newsItem = newsItems[(indexPath?.row)!]
            news.admin = admin
        } else if let addItem = segue.destination as? AddNewsItemVC {
            addItem.organisationID = organisationID
            addItem.location = location
        }
    }
    
    // MARK: - Actions
    @IBAction func addNewsItem(_ sender: Any) {
        performSegue(withIdentifier: "addNewsItem", sender: nil)
    }
}

// MARK: - References

// 1. http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
