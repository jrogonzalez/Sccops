//
//  NewsDetailViewController.swift
//  Scoops
//
//  Created by jro on 24/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MapKit

class NewsDetailViewController: UIViewController {
    
    var newsTitle: String?
    var newsText: String = ""
    var newsAuthor: String = ""
    var newsPhoto: UIImage?
    var newsPosition: (Double, Double)?
    
    init(withTitle newsTitle: String, newsText: String, newsAuthor: String, image: UIImage, position: (Double, Double)){
        self.newsTitle = newsTitle
        self.newsText = newsText
        self.newsAuthor = newsAuthor
        self.newsPhoto = image
        self.newsPosition = position
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    @IBAction func backToNews(_ sender: AnyObject) {
//        performSegue(withIdentifier: "backNews", sender: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if segue.identifier == "backNews" {
//            let vc = segue.destination as! NewsTableViewController
//        }
    }
    
    

}
