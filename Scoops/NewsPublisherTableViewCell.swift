//
//  NewsPublisherTableViewCell.swift
//  Scoops
//
//  Created by jro on 28/10/2016.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NewsPublisherTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsHead: UILabel!
    @IBOutlet weak var newsPublished: UISwitch!
    @IBAction func publishNews(_ sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
