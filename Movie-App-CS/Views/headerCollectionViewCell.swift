//
//  nowPlayingCell.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import UIKit

class headerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerOverview: UILabel!
    
    @IBOutlet weak var headerPageControl: UIPageControl!
    
    func updatePageControl(pageIndex:Int,totalPageNumber:Int){
        headerPageControl.numberOfPages = totalPageNumber
        headerPageControl.currentPage = pageIndex
        
    }
    
    public func configure(with model:String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        headerImage.sd_setImage(with: url, completed: nil)
    }
    
    
    
}
