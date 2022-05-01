//
//  MovieDetailScreenViewController.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import UIKit
import SDWebImage

class MovieDetailScreenViewController: UIViewController {
    
    var movieID = 0
    
    var detailedMovie = [Movie]()
    
    @IBOutlet weak var detailMovieTitle: UILabel!
    @IBOutlet weak var detailMovieDate: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailOverview: UITextView!
    @IBOutlet weak var detailAvgPoint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getNowPlaying(movieId: movieID)
        
    }

    private func getNowPlaying(movieId : Int){
        
        APICaller.shared.getMovieDetail(movieID: movieId) { results in
            switch results {
            case .success(let detail):
                
                self.detailedMovie = detail
                DispatchQueue.main.sync {
                    self.updateUI()
                }
            case .failure(let error):
                print(error)
            }
        }
            
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK: Updating the UI with ID API Call
    func updateUI(){
        self.detailMovieTitle.text = detailedMovie[0].original_title
        self.detailOverview.text = detailedMovie[0].overview
        self.detailMovieDate.text = detailedMovie[0].release_date
        self.detailAvgPoint.text = "\(detailedMovie[0].vote_average!)"
        if let poster = detailedMovie[0].poster_path {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster)") else { return }
            self.detailImageView.sd_setImage(with: url, completed: nil)
        }else{
            self.detailImageView.image = UIImage(named: "Overlay")
        }
        
    }
   
  

}


