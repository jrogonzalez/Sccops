//
//  LoginViewController.swift
//  Scoops
//
//  Created by jro on 24/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func enterLogin(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "newsTable", sender: nil)
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
        
        if segue.identifier == "newsTable" {
            
            let vc = segue.destination as! NewsTableViewController
//            vc.client = client
//            vc.container = sender as? AZSCloudBlobContainer
            
        }
        

        
        
        
    }
    

}
