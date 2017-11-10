//
//  ViewController.swift
//  test
//
//  Created by yuting jiang on 2017/11/6.
//  Copyright © 2017年 yuting jiang. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        tableView.delegate = self
//        tableView.dataSource = self
        fetchArticles()
    }
    
    
    open func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string:"https://newsapi.org/v1/articles?source=techcrunch&sortBy=top&apiKey=7a3cab77898944b4a59bb8c2b499630c")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesFromeJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromeJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.imageUrl = urlToImage
                            article.url = url
                            
                            
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView .reloadData()
                }
                
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func LoadImage() {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
//        cell.title.text = "This Is A Test! This Is A Test! This Is A Test! This Is A Test!"
//        cell.desc.text = "texttexttexttexttexttext"
        cell.author.text = self.articles?[indexPath.item].author
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.title.text = self.articles?[indexPath.item].headline
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
//        if let url = self.articles?[indexPath.item].imageUrl {
//            cell.img.downloadImage(from: url)
//            
//        }
//        Alamofire.request(.GET,  self.articles?[indexPath.item].imageUrl).response() {
//            (_, _, data, _) in
//            let image = UIImage(data: data as! NSData)
//            cell.img = image
//        }
        
        return cell
 
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebviewViewController
        webViewController.url = self.articles?[indexPath.item].url
        self.present(webViewController, animated: true, completion: nil)
    }

}


extension UIImageView {
    func downloadImage (from url: String) {
        let urlRequest = URLRequest(url:URL(string: url)!)
        //var imageView: UIImageView!
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                //imageView = self.image
            }
        }
        task.resume()
        //return imageView
        
    }
}
