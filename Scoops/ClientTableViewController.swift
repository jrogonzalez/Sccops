	//
//  ClientTableViewController.swift
//  Scoops
//
//  Created by jro on 27/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class ClientTableViewController: UITableViewController {
    
    var client: MSClient?
    var model : [News] = []
    var tableMS : MSTable?
    var cloudClient: AZSCloudBlobClient?
    var container: AZSCloudBlobContainer?
    final let CONTAINER_NAME = "boot3"
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "NewsTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "NewsTableViewCell")
        
        tableMS = client?.table(withName: "News")
        
        readContainer()
        
        readAllNews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Services
    func readAllNews() {
        
        
        client?.invokeAPI("readAllClientRecords",
                          body: nil,
                          httpMethod: "GET",
            parameters: [ "published": true],
            headers: nil,
            completion: { (result, response, error) in
                
                if let _ = error {
                    print(error)
                    return
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
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
        
        
        cell.newsHead.text = news.newsText
        cell.newAuthor.text = news.newsAuthor
        cell.newsHead.text = news.newsTitle
        //
        //        cell.preservesSuperviewLayoutMargins = false
        //        cell.separatorInset = UIEdgeInsets.init(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        //        cell.layoutMargins = UIEdgeInsets.init(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = model[indexPath.row]
        
        performSegue(withIdentifier: "newsSelected", sender: news)
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
            vc.origenClient = true;
        }
    }
    

}
