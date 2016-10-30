//
//  NewNewsViewController.swift
//  Scoops
//
//  Created by jro on 26/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices
import CoreLocation
import AddressBookUI

typealias newsRecord = Dictionary<String, AnyObject>

class NewNewsViewController: UIViewController {

    
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsTitle: UITextField!
    @IBOutlet weak var newsAuthor: UITextField!

    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var published: UISwitch!
    
    var location: CLLocation?
    var client : MSClient?
    var tableMS : MSTable?
    var cloudClient: AZSCloudBlobClient?
    var cloudContainer: AZSCloudBlobContainer?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locationName: String = ""
    var locationManager : CLLocationManager?
    var hasLocation : Bool = false
    
    @IBAction func buttonClicked(sender: UIButton) {
//        if mySwitch.on {
//            myTextField.text = "The Switch is Off"
//            println("Switch is on")
//            mySwitch.setOn(false, animated:true)
//        } else {
//            myTextField.text = "The Switch is On"
//            mySwitch.setOn(true, animated:true)
//        }
    }
    
    
    
    @IBAction func saveNewNews(_ sender: AnyObject) {
        saveNews()
    }
    
    //MARK: -
    @IBAction func takePhoto(_ sender: AnyObject) {
        // Crear una instancia de UIImagePicker
        let picker = UIImagePickerController()
        
        // Configurarlo
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            // me conformo con el carrete
            picker.sourceType = .photoLibrary
        }
        
        
        picker.delegate = self
        
        // Mostrarlo de forma modal
        self.present(picker, animated: true) {
            // Por si quieres hacer algo nada más
            // mostrarse el picker
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.newsPhoto.image = UIImage(imageLiteralResourceName: "noImage.png")
        self.tableMS = client?.table(withName: "News")
        
        activeLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: - Azure operations
    
    func callAPI(){
        client?.invokeAPI("APIV1",
                          body: nil,
                          httpMethod: "GET",
                          //parameters: nil,
                          parameters: [ "title": newsTitle.text],
                          headers: nil,
                          completion: { (result, response, error) in
                            
                            if let _ = error {
                                print(error)
                                return
                            }
                            
                            print(result)
        })
    }
    
    func saveNews() {
        
        //Guardo la imagen en el blob correspondiente
        let imageName = uploadBlob(image: self.newsPhoto.image!)
        
        //Creo la noticia
        let news = News(Title: self.newsTitle.text!,
             text: self.newsText.text,
             author: self.newsAuthor.text!,
             photo: imageName,
             published: self.published.isOn,
             longitude: self.longitude,
             latitude: self.latitude,
             averageRate: 0.0,
             publishedDate: Date(),
             locationName: self.locationName)
        
        
        
        //Guardo la noticia en la tabla
        let dict = news.tranformToDictionary()
//        let idUsuario = client?.currentUser.debugDescription
        
        let dict2: [String: Any] = ["Title" : news.newsTitle as String,
                     "Text" : news.newsText as String,
                     "Author" : news.newsAuthor as String,
                     "Photo" : news.newsPhotoName as String,
                     "Published" : news.published as Bool,
                     "Latitude" : news.newsLatitude as Double,
                     "Longitude" : news.newsLongitude  as Double,
                     "AverageRate" : news.averageRate as Double ,
                     "PublishedDate" : news.publishedDate! as Date,
                     "LocationName" : news.locationName! as String]
        
        self.tableMS?.insert(dict2) { (results, error) in
            if let _ = error {
                print(error)
                return
            }
            
            print(results)
            let alert = UIAlertController(title: "Scoops", message: "Noticia añadida correctamente", preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                 self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(actionOk)
            
            self.present(alert, animated: true, completion: nil)
            
           
        }
             
        
    }
    
    func newContainer(_ name: String) {
        
        let blobContainer = cloudClient?.containerReference(fromName: name.lowercased())
        
        blobContainer?.createContainerIfNotExists(with: AZSContainerPublicAccessType.container,
                                                  requestOptions: nil,
                                                  operationContext: nil,
                                                  completionHandler: { (error, result) in
                                                    
                                                    if let _  = error {
                                                        print(error)
                                                        return
                                                    }
                                                    
                                                    if result {
                                                        print("Exito ....... Container creado")
//                                                        self.readAllContainers()
                                                    } else {
                                                        print("Ya existe y no lo vuelvo a crear")
                                                    }
                                                    
        })
    }
    

    
    func eraseContainer(_ container: AZSCloudBlobContainer)  {
        container.deleteIfExists { (error, results) in
            
            if let _ = error {
                print(error)
                return
            }
            
//            if results {
//                self.readAllContainers()
//            }
        }
    }
    
    
    func uploadBlob(image: UIImage) -> String{
        
        // crear el blob local
        let blobName = UUID().uuidString
        
        let myBlob = cloudContainer?.blockBlobReference(fromName: blobName)
        
        myBlob?.upload(from: UIImageJPEGRepresentation(image, 0.5)!, completionHandler: { (error) in
            
//            print(error)
            
        })
        
        return blobName
        
    }
    
    func uploadBlobWithSAS()  {
        
        
        do {
            
            let conti = cloudClient?.containerReference(fromName: (self.cloudContainer?.name)!)
            
            let theBlob = conti?.blockBlobReference(fromName: UUID().uuidString)
            // tomamos una foto o la cogemos de los recursos
            
            let image = UIImage(named: "winter-is-coming.jpg")
            
            // subir
            
            theBlob?.upload(from: UIImageJPEGRepresentation(image!, 0.5)!, completionHandler: { (error) in
                
//                if let _ = error {
//                    print(error)
//                    return
//                }
//                self.readAllBlobs()
                let errorCaca = error
            })
            
            
            
        } catch let ex {
            print(ex)
        }
        
    }
    
    
    func eraseBlobBlock(_ theBlob: AZSCloudBlockBlob) {
        
        theBlob.delete { (error) in
            
            if let _ = error {
                print(error)
                return
            }
            
//            self.readAllBlobs()
            
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func removeCurrentPhoto(){
        let oldBounds = self.newsPhoto.bounds
        
        // Animación
        UIView.animate(withDuration: 0.9,
                       animations: {
                        self.newsPhoto.alpha = 0
                        self.newsPhoto.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                        self.newsPhoto.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                        
        }) { (finished: Bool) in
            // Dejar todo como estaba
            self.newsPhoto.bounds = oldBounds
            self.newsPhoto.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.newsPhoto.alpha = 1
            
            // Actualizamos
//            self.model.photo?.image = nil
//            self.syncModelView()
        }
        
        
    }
    
    

}

//MARK: - Delegates
extension NewNewsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        newsPhoto.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) {
            //
        }
        
    }
}

//Mark: - lifeCycle
extension NewNewsViewController: CLLocationManagerDelegate{
    
    // se llama una sola vez
    public func activeLocation() {
        //hay que activar un par de propiedades dentro del info.plist (NSLocationAlwaysUsageDescription y NSLocationWhenInUseUsageDescription) con los valores que deseemos que aparezcan en la aplicacion al pedirte permiso para acceder a a geolocalizacion
        //http://stackoverflow.com/questions/24050633/implement-cllocationmanagerdelegate-methods-in-swift/24056771#24056771
        
        
        let status = CLLocationManager.authorizationStatus()
        
        if ((status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.notDetermined) && CLLocationManager.locationServicesEnabled()){
            //We are authorized
            self.locationManager = CLLocationManager.init()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.startUpdatingLocation()
            
            // only take the recent data
            let deadlineTime = DispatchTime.now() + .seconds(30)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                print("DispatchAfter : \(Date())")
                self.zapLocationManager()
            }
        }
    }
    
    func zapLocationManager(){
        // Stop
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error en la GEOLOCALIZACION")
    }
    
    
    //MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Stop
        self.zapLocationManager()
        
        if !self.hasLocation {
            // take the last location
            let loc = locations.last
            
            self.latitude = (loc?.coordinate.latitude)!
            self.longitude = (loc?.coordinate.longitude)!
            
            let geocoder = CLGeocoder()
            
            print("-> Finding user address...")
            
            geocoder.reverseGeocodeLocation(loc!, completionHandler: {(placemarks, error)->Void in
                var placemark:CLPlacemark!
                
                if error == nil && (placemarks?.count)! > 0 {
                    placemark = (placemarks?[0])! as CLPlacemark
                    
                    var addressString : String = ""
                    if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
                        if placemark.country != nil {
                            addressString = placemark.country!
                        }
                        if placemark.subAdministrativeArea != nil {
                            addressString = addressString + placemark.subAdministrativeArea! + ", "
                        }
                        if placemark.postalCode != nil {
                            addressString = addressString + placemark.postalCode! + " "
                        }
                        if placemark.locality != nil {
                            addressString = addressString + placemark.locality!
                        }
                        if placemark.thoroughfare != nil {
                            addressString = addressString + placemark.thoroughfare!
                        }
                        if placemark.subThoroughfare != nil {
                            addressString = addressString + placemark.subThoroughfare!
                        }
                    } else {
                        if placemark.subThoroughfare != nil {
                            addressString = placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            addressString = addressString + placemark.thoroughfare! + ", "
                        }
                        if placemark.postalCode != nil {
                            addressString = addressString + placemark.postalCode! + " "
                        }
                        if placemark.locality != nil {
                            addressString = addressString + placemark.locality! + ", "
                        }
                        if placemark.administrativeArea != nil {
                            addressString = addressString + placemark.administrativeArea! + " "
                        }
                        if placemark.country != nil {
                            addressString = addressString + placemark.country!
                        }
                    }
                    
                    print(addressString)
                    self.locationName = addressString
                }else{
                    self.locationName = "It was impossible obtain the Location"
                }
            })
            
            
        }else{
            print("We should never reach here")
        }
        
        
    }
    
}



