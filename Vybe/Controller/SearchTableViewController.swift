//
//  SearchTableViewController.swift
//  Vybe
//
//  Created by Terry Bridges on 05/08/2019.
//  Copyright © 2019 Terry Bridges. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class SearchTableViewController: UITableViewController {
    
    var names = [String]()
    
    var searchURL = "https://api.spotify.com/v1/search?q=abba&type=track&market=US"
    let parameter = Parameters()
    
    typealias JSONStandard = [String: AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callAlamo(url: searchURL)
     
    }

    // MARK: - Table view data source
    
    func callAlamo(url: String) {
        
        let parameters = parameter.parameters
        
        AF.request(url, method: .get, parameters: parameters).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    
    
    func parseData (JSONData : Data) {
        
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        let name = item["name"] as! String
                        names.append(name)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

}
