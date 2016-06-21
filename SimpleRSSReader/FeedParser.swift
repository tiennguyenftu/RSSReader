//
//  FeedParser.swift
//  SimpleRSSReader
//
//  Created by Tien 95 on 6/21/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class FeedParser: NSObject, NSXMLParserDelegate {
    private var rssItems: [(title: String, description: String, pubDate: String, link: String)] = []
    
    var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    private var parserCompletionHandler:([(title: String, description: String, pubDate: String, link: String)] -> Void)?
    
    
    
    func parseFeed(feedUrl: String, completionHandler:([(title: String, description: String, pubDate: String, link: String)] -> Void)?) {
        self.parserCompletionHandler = completionHandler
        let request = NSURLRequest(URL: NSURL(string: feedUrl)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            //Parse XML Data
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    //MARK: - NSXMLParserDelegate 
    
    func parserDidStartDocument(parser: NSXMLParser) {
        rssItems = []
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "link": currentLink += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate, link: currentLink)
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.localizedDescription)
    }
    
}
