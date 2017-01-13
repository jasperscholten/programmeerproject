//
//  NewsAdminVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class NewsAdminVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!

    var admin = Bool()
    let newsTitles = ["Nieuwjaarsborrel groot succes.", "De vriezer is weer aangevuld met nieuwe maaltijden.", "Keurige omzet periode 12.", "De kerstpakketten liggen klaar."]
    let newsDate = ["07-01-17", "03-01-17", "22-12-16", "15-12-16"]
    let textSample = ["Bla bla dingen nieuwjaarsborrel was een succes ja dat zeggen ze altijd maar wel gewonnen met bowlen.", "Lekker hoor eten hertenstoofvlees met pompoencompote en appel veenbessen echt waar.", "Nou gefeliciteerd joh gaan we vieren.", "Bla bla hopelijk gaat V&D dit jaar niet failliet waardoor de bonnen niets meer waard zijn."]
    var image: [Any] = [#imageLiteral(resourceName: "nieuwjaar"), #imageLiteral(resourceName: "vriezer"), #imageLiteral(resourceName: "resultaat"), #imageLiteral(resourceName: "kerstpakket")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
        if admin == false {
            self.navigationItem.rightBarButtonItem = nil
        } /*else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsItemAdmin", for: indexPath) as! NewsItemAdminCell
        
        cell.title.text = newsTitles[indexPath.row]
        cell.date.text = newsDate[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNewsItem", sender: self)
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let news = segue.destination as? NewsItemAdminVC {
            let indexPath = self.newsTableView.indexPathForSelectedRow
            news.itemTitle = newsTitles[indexPath!.row]
            news.itemDate = newsDate[indexPath!.row]
            news.itemText = textSample[indexPath!.row]
            news.image = image[indexPath!.row] as! UIImage
        }
    }
    
    // MARK: - Action
    
    @IBAction func addNewsItem(_ sender: Any) {
        performSegue(withIdentifier: "addNewsItem", sender: nil)
    }
}
