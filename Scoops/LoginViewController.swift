//
//  LoginViewController.swift
//  Scoops
//
//  Created by jro on 24/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var client: MSClient = MSClient(applicationURLString:"https://jroapp-mbaas.azurewebsites.net")
    var model : [News] = []
    var cloudClient: AZSCloudBlobClient?
    
    @IBAction func enterLogin(_ sender: AnyObject) {
        
        doLoginInFacebook()
        
    }

    @IBAction func enterClient(_ sender: AnyObject) {

        performSegue(withIdentifier: "newsTable", sender: nil)
    }
    	
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAzureClient()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: - Azure operations
    
    func doLoginInFacebook()  {
        client.login(withProvider: "facebook",
                     controller: self,
                     animated: true) { (user, error) in
                        if let _ = user {
                            //cargo las variables del AZSClient
                            
                            
                            self.performSegue(withIdentifier: "newsTablePublisher", sender: nil)
                        }
        }
    }
    
    func setupAzureClient()  {
        
        do {
            let sas = "sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2016-10-31T00:49:49Z&st=2016-10-30T16:49:49Z&spr=https&sig=dgn7r0zcXG2%2B2fEkTQHBshZH6zQdoDjAcu6m31odEqE%3D"
            
            let credentials = AZSStorageCredentials(sasToken: sas, accountName: "jrostorage")
            
            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
            
            cloudClient = account.getBlobClient()
            
        } catch let error {
            print(error)
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "newsTable" {
            
            let vc = segue.destination as! ClientTableViewController
            vc.client = self.client
            vc.cloudClient = self.cloudClient
            
            
        } else if segue.identifier == "newsTablePublisher" {
            let vc = segue.destination as! NewsTableViewController
            vc.client = self.client
            vc.cloudClient = self.cloudClient
        }
        

        
        
        
    }
    


}
