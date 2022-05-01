//
//  APICaller.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import Foundation


struct Constants{
    static let API_KEY = "0521010d85f93dc56dac28cbb3e52ab2"
    static let BASE_URL = "https://api.themoviedb.org/3/movie/"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getNowPlaying(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string:  "\(Constants.BASE_URL)now_playing?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
       
    
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(MovieList.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
    }
    
    func getUpcoming(pageNumber: Int,pagination:Bool = false,completion: @escaping (Result<[Movie],Error>)-> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 1 : 0.5)) {
            
            guard let url = URL(string: "\(Constants.BASE_URL)upcoming?api_key=\(Constants.API_KEY)&language=en_US&page=\(pageNumber)") else {return}
            
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do{
                    let results = try JSONDecoder().decode(MovieList.self, from: data)
                    
                    completion(.success(results.results))
                    
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
                
            }
            task.resume()
        }
        
    }
    
    
    
    func getMovieDetail(movieID: Int, completion: @escaping (Result<[Movie],Error>)-> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)\(movieID)?api_key=\(Constants.API_KEY)&language=en_US") else {return}
        
       
    
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(Movie.self, from: data)
                
                completion(.success([results]))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
        
    }
    
    
}
