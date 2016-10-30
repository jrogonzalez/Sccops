//
//  MapViewController.swift
//  Scoops
//
//  Created by jro on 26/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKAnnotation {

    @IBOutlet weak var mapView: MKMapView!

    var loc : CLLocation?
    var latitude: Double?
    var longitude: Double?
    var locationName: String = ""
    
    
    public var coordinate: CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        }
    }

    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    
    
    //MARK - Initializers
    init(withLocalization localization: CLLocation?){
        self.loc = localization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    //MARK - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        synchronizeView()
        self.title = locationName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func synchronizeView(){
//        if let loc = self.loc {
        if let _ = longitude, let _ = latitude {
            let location = CLLocation(latitude: latitude!, longitude: longitude!)
            centerMapOnLocation(location: location)
            mapView.addAnnotation(self as! MKAnnotation)
        }else{
            centerMapOnLocation(location: initialLocation)
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}


