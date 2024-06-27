//
//  LocalizedString.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 27.06.2024.
//

enum LocalizedString {
    
    //MARK: - Movies Screen
    
    enum MoviesScreen: String, Localizable {
        case title = "screen_title"
        case searchNothingFound = "search_nothing_found"
        case sortedBy = "sorted_by"
        case cancel = "cancel"
        case ok = "ok"
    }
    
    // MARK: - Searchbar
    
    enum SearchBar: String, Localizable {
        case placeholder = "searchbar_placeholder"
    }
    
    // MARK: - SortOptions
    
    enum SortOptions: String, Localizable {
        case alphabet = "alphabet_sorted"
        case releaseDate = "release_date_sorted"
        case userScore = "user_score_sorted"
    }
    
    //MARK: - Movies Screen
    
    enum MovieDetailsScreen: String, Localizable {
        case playTrailer = "play_trailer"
        case rating = "rating"
    }
}

