//
//  upcomingCell.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import UIKit
import SDWebImage
class upcomingTableViewCell: UITableViewCell {

    @IBOutlet weak var upcomingImage: UIImageView!
    @IBOutlet weak var upcomingTitle: UILabel!
    @IBOutlet weak var upcomingOverview: UILabel!
    @IBOutlet weak var upcomingDate: UILabel!
    
    var upcomingMoviesArray = [Movie]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        upcomingImage.layer.cornerRadius = 5
    
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model:String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        upcomingImage.sd_setImage(with: url, completed: nil)
    }

}
