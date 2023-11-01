//
//  OmdbModel.swift
//  Movie Poster App
//
//  Created by Furkan BAŞOĞLU on 1.11.2023.
//

import Foundation

struct OmdbModel {
    var title: String?
    var year: String?
    var genre: String?
    var poster: String?
    var plot: String?
    var id: String
                        
    init(_ dict: [String: Any]) {
        self.title = dict["Title"]as? String ?? ""
        self.year = dict["Year"]as? String ?? ""
        self.genre = dict["Genre"]as? String ?? ""
        self.poster = dict["Poster"]as? String ?? ""
        self.plot = dict["Plot"]as? String ?? ""
        self.id = (dict["imdbID"]as? String ?? "").replacingOccurrences(of: "tt", with: "")
    }
}
