	//
//  NewsTableViewController.swift
//  Scoops
//
//  Created by jro on 24/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MobileCoreServices
    
typealias NewsRecord = Dictionary<String, AnyObject>

class NewsTableViewController: UITableViewController {
    
    var model : [News]
    var client: MSClient?
    var publisher : Bool = false
    var tableMS : MSTable?
    var cloudClient: AZSCloudBlobClient?
    var container: AZSCloudBlobContainer?
    final let CONTAINER_NAME = "boot3"
    
    
    @IBAction func addNewNews(_ sender: AnyObject) {
        print("add news selected")
        
        performSegue(withIdentifier: "newNews", sender: nil)
    }
    
    //MARK: - Initializers
    init(WithNews news: [News]){
        self.model = news
        client = MSClient(applicationURLString:"https://jroapp-mbaas.azurewebsites.net")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.model = []
        super.init(coder: aDecoder)
    }
    

    


    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let nibName = UINib(nibName: "NewsPublisherTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "NewsPublisherTableViewCell")
        
        tableMS = client?.table(withName: "News")
        
        readContainer()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readAllNews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if model.count > 0 {
            return 1
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPublisherTableViewCell", for: indexPath) as! NewsPublisherTableViewCell
        
        let news = model[indexPath.row]
        
        DispatchQueue.global(qos: .default).async {
            
            cell.newsImage.image = UIImage(imageLiteralResourceName: "noImage.png")
            news.newsPhoto = cell.newsImage.image
            
            
            let theBlob = self.container?.blockBlobReference(fromName: news.newsPhotoName)
            
            theBlob?.downloadToData { (error, data) in
                
                if let _ = error {
                    print(error)
                    return
                }
                
                if let _ = data {
                    let img = UIImage(data: data!)
                    print("Imagen ok")
                    
                    DispatchQueue.main.async {
                        cell.newsImage.image = img
                        news.newsPhoto = img
                    }
                }
            }
        }

        
        cell.newsHead.text = news.newsTitle
        cell.newsPublished.isOn = news.published

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = model[indexPath.row]
        
        performSegue(withIdentifier: "newsSelected", sender: news)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model[indexPath.row]
            
            self.deleteNews(item: item)
            self.model.remove(at: indexPath.row)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: - Services
    func readAllNews() {

        
        client?.invokeAPI("readAllRecords",
                          body: nil,
                          httpMethod: "GET",
//                          parameters: nil,
                                      parameters: [ "Published": "1"],
            headers: nil,
            completion: { (result, response, error) in
                
                if let _ = error {
                    print(error)
                    return
                }
                
                if self.model.count > 0 {
                    self.model.removeAll()
                }
                
                if let _ = result {
                    
                    let json = result as! [NewsRecord]
                    
                    for item in json {
                        let news = News(Title: item["Title"] as! String,
                                        text: item["Text"] as! String,
                                        author: item["Author"] as! String,
                                        photo: item["Photo"] as! String,
                                        published: item["Published"] as! Bool,
                                        longitude: item["Longitude"] as! Double,
                                        latitude: item["Latitude"] as! Double,
                                        averageRate: item["AverageRate"] as! Double,
                                        publishedDate: item["PublishedDate"] as! Date,
                                        locationName: item["LocationName"] as! String)
                        
                        self.model.append(news)
                    

                    }
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                }
                
        })
    }
    
    func updateNews(item: News){
        
        tableMS?.update(item.tranformToDictionary(), completion: {  (results, error) in
            if let _ = error {
                print(error)
                return
            }
            
            //Refresh table
            self.readAllNews()
        })
    }
    
    func deleteNews(item: News) {
        tableMS?.delete(item.tranformToDictionary(), completion: { (results, error) in
            if let _ = error {
                print(error)
                return
            }
            
            //Refresh table
            self.readAllNews()
        })
    }
    
    func readContainer()  {
        
        container = cloudClient?.containerReference(fromName: CONTAINER_NAME)
        
        //Creamos el container y volvemos a buscar la rederencia
        if container == nil {
            newContainer()
            container = cloudClient?.containerReference(fromName: CONTAINER_NAME)
        }
    }
    
    func newContainer() {
        
        let blobContainer = cloudClient?.containerReference(fromName: CONTAINER_NAME)
        
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

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newsSelected" {
            
            let news = sender as! News
            
            let vc = segue.destination as! NewsDetailViewController
            vc.model = news
            vc.origenClient = false
            
        } else if segue.identifier == "newNews" {
            let vc = segue.destination as! NewNewsViewController
            vc.client = client
            vc.cloudContainer = container
        }
        
    }
    

}
