//
//  DetailViewController.swift
//  iTunesTop25
//
//  Created by Aarnav Ram on 31/03/17.
//  Copyright © 2017 Aarnav Ram. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: NSDictionary?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            print(movie)
            let movieName = movie.value(forKeyPath: "im:name.label") as! String
            titleLabel.text = movieName
            
            let imageInfo = movie.value(forKey: "im:image") as! NSArray
            let imageInfoEntry = imageInfo[2] as! NSDictionary
            let imageURL = imageInfoEntry.value(forKey: "label") as! String
            posterView.setImageWith(URL(string: imageURL)!)
            
            let releaseDate = movie.value(forKeyPath: "im:releaseDate.attributes.label") as! String
            releaseDateLabel.text = releaseDate
            
            let price = movie.value(forKeyPath: "im:price.label") as! String
            priceLabel.text = price
            
            let descr = movie.value(forKeyPath: "summary.label") as! String
            descrLabel.text = descr
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func oniTunesButtonPressed(_ sender: Any) {
        if let movie = movie {
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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
