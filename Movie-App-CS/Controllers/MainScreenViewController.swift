//
//  ViewController.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import UIKit



class MainScreenViewController: UIViewController ,UIScrollViewDelegate {

    // Empty Array Declaration For Holding Data From API
    var nowPlayingMovies  = [Movie]()
    var upcomingMovies = [Movie]()
    var appendMovies = [Movie]()
    
    // Parameters
    var upcomingMovieID = 0
    var pageNumber = 1
    var timer : Timer?
    var currentCellIndex = 0
    
    // Outlets
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var upcomingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial Setup
        getNowPlaying()
        getUpcomingMovies(pageID: pageNumber , isPaginating: false)
        setupView()
        startTimer()
        
        // Refresh Control
        self.upcomingTableView.refreshControl = UIRefreshControl()
        self.upcomingTableView.refreshControl?.addTarget(self, action: #selector(RefreshData), for: .valueChanged)
    }
    
    //MARK: REFRESH DATA FOR TABLEVIEW
    
    @objc func RefreshData(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.upcomingTableView.refreshControl?.endRefreshing()
            self.appendMovies.removeAll()
            self.upcomingMovies.removeAll()
            self.pageNumber = 1
            self.getUpcomingMovies(pageID: self.pageNumber, isPaginating: false)
            self.upcomingTableView.reloadData()
            
        }
        
    }
    
    
    //MARK: TIMER FOR HEADER
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    
    //MARK: HEADER PAGE CONTROL SETUP - SlideShow
    
    @objc func moveToNextIndex(){
        if currentCellIndex < nowPlayingMovies.count - 1 {
            currentCellIndex += 1
            
        }else{
            currentCellIndex = 0
        }
        
        headerCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    
    
    
    //MARK: SEGUE FOR DETAILVIEW WITH ID
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailVC = segue.destination as! MovieDetailScreenViewController
            detailVC.movieID = upcomingMovieID
            
        }
    }
    

    //MARK: API CALLS
    private func getNowPlaying(){
        
        APICaller.shared.getNowPlaying { results in
            switch results {
            case .success(let movies):
                
                self.nowPlayingMovies = movies
                DispatchQueue.main.async {
                    self.headerCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
            
    }
        
    private func getUpcomingMovies(pageID: Int, isPaginating : Bool ){
        APICaller.shared.getUpcoming(pageNumber: pageID, pagination: isPaginating) { results in
            switch results {
            case .success(let upmovies):
                
                DispatchQueue.main.async {
                    self.upcomingMovies = upmovies
                    self.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: DELEGATIONS FOR TABLEVIEW AND COLLECTIONVIEW FOR SETUP
    
    private func setupView(){
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
    }
    
    
    
    
    
    //MARK: PAGINATION SETUP FOR TABLEVIEW
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (upcomingTableView.contentSize.height - 100 - scrollView.frame.size.height)  {
            
            APICaller.shared.getUpcoming(pageNumber: pageNumber + 1, pagination: true ) { results in
                switch results {
                case .success(let upmovies):
                    
                    DispatchQueue.main.sync {
                        self.appendMovies = upmovies
                        self.upcomingMovies.append(contentsOf: self.appendMovies)
                        self.upcomingTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        self.appendMovies.removeAll()
        if pageNumber < 10 {
            pageNumber += 1
        }else {
            pageNumber = 0
        }
        
        
    }

}


//MARK: EXTENSION FOR COLLECTIONVIEW AND TABLEVIEW ->
//TODO: HANDLE IT WITH VIEWMODEL

extension MainScreenViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = headerCollectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! headerCollectionViewCell
        cell.configure(with: nowPlayingMovies[indexPath.row].poster_path!)
        cell.headerTitle.text = nowPlayingMovies[indexPath.row].original_title
        cell.headerOverview.text = nowPlayingMovies[indexPath.row].overview
        cell.updatePageControl(pageIndex: currentCellIndex, totalPageNumber: self.nowPlayingMovies.count - 1)
        return cell
    }
    
    
    
    
}


extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingTableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingTableViewCell
        
        cell.upcomingDate.text = upcomingMovies[indexPath.row].release_date
        cell.upcomingTitle.text = upcomingMovies[indexPath.row].original_title
        cell.upcomingOverview.text = upcomingMovies[indexPath.row].overview
        upcomingMovieID = upcomingMovies[indexPath.row].id
        if upcomingMovies[indexPath.row].poster_path != nil {
            cell.configure(with: upcomingMovies[indexPath.row].poster_path!)
        }else{
            cell.upcomingImage.image = UIImage(named: "Overlay")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        upcomingMovieID = upcomingMovies[indexPath.row].id
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
}
