//
//  NewsTableViewController.swift
//  Scoops
//
//  Created by jro on 24/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    let model: [String] = ["Noticia 1","Noticia 2","Noticia 3","Noticia 4","Noticia 5","Noticia 6","Noticia 7","Noticia 8","Noticia 9","Noticia 10"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let nibName = UINib(nibName: "NewsTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "NewsTableViewCell")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        cell.newsImage.image = UIImage(imageLiteralResourceName: "noImage.png")
        cell.newAuthor.text = "Autor \(indexPath.row)"
        cell.newsHead.text = model[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.init(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        cell.layoutMargins = UIEdgeInsets.init(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let new = model[indexPath.row]
        
        performSegue(withIdentifier: "newsSelected", sender: new)
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
            
            let vc = segue.destination as! NewsDetailViewController
//            vc.newsTitle = ""
//            vc.newsText="LorenIpsum dolo...."
//            vc.newsAuthor="Perez Reverte"
//            vc.newsPhoto = UIImage(imageLiteralResourceName: "noImage.png")
//            vc.newsPosition = (0.0,0.0)
            
            
            
        }
        
    }
    

}
