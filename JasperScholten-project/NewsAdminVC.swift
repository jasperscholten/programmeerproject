//
//  NewsAdminVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class NewsAdminVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!

    var admin = Bool()
    var organisation = String()
    var location = String()
    let newsRef = FIRDatabase.database().reference(withPath: "News")
    var newsItems = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
        if admin == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Retrieve data from Firebase.
        newsRef.observe(.value, with: { snapshot in
            
            var newItems: [News] = []
            
            for item in snapshot.children {
                let newsData = News(snapshot: item as! FIRDataSnapshot)
                if newsData.organisation == self.organisation && newsData.location == self.location {
                    newItems.append(newsData)
                }
            }
            self.newsItems = newItems
            self.newsTableView.reloadData()
        })
        
    }

    // MARK: - Tableview
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let news = segue.destination as? NewsItemAdminVC {
            let indexPath = newsTableView.indexPathForSelectedRow
            news.newsItem = newsItems[(indexPath?.row)!]
            news.admin = admin
        } else if let addItem = segue.destination as? AddNewsItemVC {
            addItem.organisation = organisation
            addItem.location = location
        }
    }
    
    // MARK: - Action
    
    @IBAction func addNewsItem(_ sender: Any) {
        performSegue(withIdentifier: "addNewsItem", sender: nil)
    }
}
