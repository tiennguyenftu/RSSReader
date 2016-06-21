//
//  NewsTableViewController.swift
//  SimpleRSSReader
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var rssItems: [(title: String, description: String, pubDate: String, link: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let feedParser = FeedParser()
        feedParser.parseFeed("https://www.apple.com/main/rss/hotnews/hotnews.rss") { (rssItems: [(title: String, description: String, pubDate: String, link: String)]) in
            self.rssItems = rssItems
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWebView" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let item = rssItems?[indexPath!.row]
            let webViewVC = segue.destinationViewController as! WebViewController
            webViewVC.urlString = item?.link
            webViewVC.title = item?.title
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        
        if let item = rssItems?[indexPath.row] {
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.dateLabel.text = item.pubDate
        }
        
        return cell
    }


}
