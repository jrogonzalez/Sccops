//
//  News.swift
//  Scoops
//
//  Created by jro on 27/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices


class News: NSObject {
    
    var newsTitle: String = ""
    var newsText: String = ""
    var newsAuthor: String = ""
    var newsPhotoName: String = ""
    var newsPhoto: UIImage?
    var newsLongitude: Double = 0.0
    var newsLatitude: Double = 0.0
    var published: Bool = false
    var publishedDate: Date?
    var averageRate: Double = 0.0
    var locationName : String?
    

    public var coordinate: CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: self.newsLatitude, longitude: self.newsLongitude)
        }
    }
    
    init(Title title: String, text: String, author: String, photo: String, published: Bool, longitude: Double, latitude: Double, averageRate: Double, publishedDate: Date, locationName: String){
        
        self.newsTitle = title
        self.newsText = text
        self.newsAuthor = author
        self.newsPhotoName = photo
        self.newsLongitude = longitude
        self.newsLatitude = latitude
        self.published = published
        self.publishedDate = publishedDate
        self.averageRate = averageRate
        self.locationName  = locationName
        
        super.init()
        
        
        
    }

    
    init(withTitle title: String, text: String, author: String, photo: String, published: Bool){
        
        self.newsTitle = title
        self.newsText = text
        self.newsPhotoName = photo
        self.newsAuthor = author
        self.published = published
        self.averageRate = 0.0
        self.publishedDate = Date()
        
        super.init()

    }
    

    
    
    func tranformToDictionary() -> Dictionary<String,AnyObject> {
        
        return ["Title" : self.newsTitle as AnyObject,
                "Text" : self.newsText as AnyObject,
                "Author" : self.newsAuthor as AnyObject,
                "Photo" : self.newsPhoto as AnyObject,
                "Published" : self.published as AnyObject,
                "Latitude" : self.newsLatitude as AnyObject,
                "Longitude" : self.newsLongitude as AnyObject,
                "AverageRate" : self.averageRate as AnyObject,
                "PublishedDate" : self.publishedDate as AnyObject,
                "LocationName" : self.locationName as AnyObject]
    }
    
    

}


