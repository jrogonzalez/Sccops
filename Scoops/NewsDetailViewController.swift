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
    

    
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsTitle: UITextField!
    @IBOutlet weak var newsAuthor: UITextField!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBAction func actionBtn1(_ sender: AnyObject) {
        btn1.imageView?.image = emptyStarImage
        btn2.imageView?.image = emptyStarImage
        btn3.imageView?.image = emptyStarImage
        btn4.imageView?.image = emptyStarImage
        btn5.imageView?.image = emptyStarImage
    }

    @IBAction func actionBtn2(_ sender: AnyObject) {
    }
    
    @IBAction func actionBtn3(_ sender: AnyObject) {
    }
    
    @IBAction func actionBtn4(_ sender: AnyObject) {
    }
    
    @IBAction func actionBtn5(_ sender: AnyObject) {
        print("BOTON 5 PULSADO")
        btn1.imageView?.image = filledStarImage
        btn2.imageView?.image = filledStarImage
        btn3.imageView?.image = filledStarImage
        btn4.imageView?.image = filledStarImage
        btn5.imageView?.image = filledStarImage
        self.view.reloadInputViews()
    }
    
    let emptyStarImage = UIImage(named: "emptyStar")
    let filledStarImage = UIImage(named: "filledStar")
    
    var rating = 0
    var ratingButtons = [UIButton]()
    
    var model: News?
    var origenClient: Bool = false
    
//    init(withTitle newsTitle: String, newsText: String, newsAuthor: String, image: UIImage, position: (Double, Double)){
    @IBAction func publishNews(_ sender: AnyObject) {
    }
    @IBOutlet weak var publishedView: UISwitch!
    @IBAction func mapSelected(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "mapSelected", sender: nil)
    }
//        self.newsTitle = newsTitle
//        self.newsText = newsText
//        self.newsAuthor = newsAuthor
//        self.newsPhoto = image
//        self.newsPosition = position
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        
//        btn1.imageView?.image = emptyStarImage
//        btn2.imageView?.image = emptyStarImage
//        btn3.imageView?.image = emptyStarImage
//        btn4.imageView?.image = emptyStarImage
//        btn5.imageView?.image = emptyStarImage
//        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.newsPhoto.image = UIImage(imageLiteralResourceName: "noImage.png")
        
        syncModelWithView()
        
        if origenClient {
            self.publishedView.isHidden = true
            self.publishedLabel.isHidden = true
            self.newsText.isEditable = false
            self.newsTitle.isEnabled = false
            self.newsAuthor.isEnabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func syncModelWithView() {
        self.newsPhoto.image = model?.newsPhoto
        self.newsTitle.text = model?.newsTitle
        self.newsAuthor.text = model?.newsAuthor
        self.newsText.text = model?.newsText
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "mapSelected" {
            let vc = segue.destination as! MapViewController
//            vc.loc = loc
            vc.longitude = model?.newsLongitude
            vc.latitude = model?.newsLatitude
            vc.locationName = (model?.locationName)!
        }
    }
    
    

}


