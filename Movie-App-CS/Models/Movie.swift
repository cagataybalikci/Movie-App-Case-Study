//
//  Movie.swift
//  Movie-App-CS
//
//  Created by Çağatay Balıkçı on 30.04.2022.
//

import Foundation



struct MovieList : Codable {
    let results: [Movie]
    
    
}

struct Movie : Codable {
    
    let id: Int
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let vote_average: Double?
    
    
}



