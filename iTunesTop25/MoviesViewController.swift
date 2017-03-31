//
//  MoviesViewController.swift
//  iTunesTop25
//
//  Created by Aarnav Ram on 31/03/17.
//  Copyright © 2017 Aarnav Ram. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies:[NSDictionary]?
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getMovies()
        refreshControl.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 128
        tableView.reloadData()
    }
    
    func getMovies() {
        let url = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=25/json")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let feed = dataDictionary.value(forKey: "feed") as? NSDictionary
                    if let feed = feed {
                        self.movies = feed.value(forKey: "entry") as? [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
            } else {
                let alertVC = UIAlertController(title: "Could not grab Movies", message: "The network may be unavailable, please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: false)
            }
        }
        refreshControl.endRefreshing()
        task.resume()
        
        
    }
    
    @IBAction func oniTunesButtonPressed(_ sender: Any) {
        let senderButton = sender as! UIButton
        let movie = movies![senderButton.tag]
        let vidAndLink = movie.value(forKeyPath: "link") as! NSArray
        let link = vidAndLink[0] as! NSDictionary
        let urlStr = link.value(forKeyPath: "attributes.href") as! String
        let url = URL(string: urlStr)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared
                .open(url!, options: [:], completionHandler: nil)
        } else {
            let alertVC = UIAlertController(title: "Could not open the movie", message: "Please try again later", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            self.present(alertVC, animated: false)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none
        cell.itunesButton.tag = indexPath.row
        if let movies = movies {
            let movie = movies[indexPath.row]
            let movieName = movie.value(forKeyPath: "im:name.label") as! String
            cell.titleLabel.text = movieName
            
            let imageInfo = movie.value(forKey: "im:image") as! NSArray
            let imageInfoEntry = imageInfo[2] as! NSDictionary
            let imageURL = imageInfoEntry.value(forKey: "label") as! String
            cell.posterView.setImageWith(URL(string: imageURL)!)
            
            let releaseDate = movie.value(forKeyPath: "im:releaseDate.attributes.label") as! String
            cell.releaseDateLabel.text = releaseDate
            
            let price = movie.value(forKeyPath: "im:price.label") as! String
            cell.priceLabel.text = price
            
        }
        return cell
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderCell = sender as! MovieTableViewCell
        let indexPath = tableView.indexPath(for: senderCell)
        let destinationVC = segue.destination as! DetailViewController
        if let movies = movies {
            destinationVC.movie = movies[indexPath!.row]
        }
        
    }
    

}
