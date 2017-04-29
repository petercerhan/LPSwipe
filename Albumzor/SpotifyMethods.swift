//
//  SpotifyMethods.swift
//  Albumzor
//
//  Created by Peter Cerhan on 3/13/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//


import Foundation

extension SpotifyClient {
    
    //Sends the top result sent to the completion handler; is a [String : AnyObject] (sent as AnyObject?)
    func searchArtist(searchString: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = [SpotifyClient.ParameterKeys.searchQuery : searchString,
                          SpotifyClient.ParameterKeys.searchType : "artist"]
        
        _ = task(getMethod: SpotifyClient.Methods.search, parameters: parameters) { result, error in
            
            if let error = error {
                print("error: \(error)")
                return
            }
            
            //check against empty array? -- return nil if empty
            guard let result = result as? [String : AnyObject],
                let artists = result["artists"] as? [String : AnyObject],
                let items = artists["items"] as? [[String : AnyObject]] else {
                    
                    print("Data not formatted correctly")
                    return
            }
            
            completion(items[0] as AnyObject?, nil)
        }
    }
    
    //The artists data sent to the completion handler is a [[String : AnyObject]] (sent as AnyObject?)
    func getRelatedArtists(forArtist artistID: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = [String : String]()
        
        let method = replace(placeholder: "id", inMethod: Methods.getRelatedArtists, value: artistID)
        
        _ = task(getMethod: method, parameters: parameters) { result, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result as? [String : AnyObject], let artistsData = result["artists"] as? [[String : AnyObject]] else {
                print("Data not formatted correctly")
                return
            }
            
            completion(artistsData as AnyObject, nil)
        }
    }
    
    //The albums data sent to the completion handler is a [[String : AnyObject]] (sent as AnyObject?)
    func getAlbums(forArtist artistID: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = ["album_type" : "album",
                          "market" : "US"]
        
        let method = replace(placeholder: "id", inMethod: Methods.getArtistAlbums, value: artistID)
        
        _ = task(getMethod: method, parameters: parameters) { result, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result as? [String : AnyObject], let albumsData = result["items"] as? [[String : AnyObject]] else {
                print("Data not formatted correctly")
                return
            }
            
            completion(albumsData as AnyObject?, nil)
        }
    }
    
    //The albums data sent to the completion handler is a [[String : AnyObject]] (sent as AnyObject?)
    func getAlbums(ids: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = ["ids" : ids]
        
        _ = task(getMethod: Methods.getAlbums, parameters: parameters) { result, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result as? [String : AnyObject], let albums = result["albums"] as? [[String : AnyObject]] else {
                print("bad data structure")
                return
            }
            
            completion(albums as AnyObject, nil)
        }
    }
    
    //The tracks data sent to the completion handler is a [[String : AnyObject]] (sent as AnyObject?)
    func getTracks(ids: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = ["ids" : ids]
        
        _ = task(getMethod: Methods.getTracks, parameters: parameters) { result, error in
        
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result as? [String : AnyObject], let tracks = result["tracks"] as? [[String : AnyObject]] else {
                print("bad data structure")
                return
            }
        
            completion(tracks as AnyObject, nil)
        }
    }
    
    //Sends the tracks data as [[String : AnyObject]] to the completion handler
    func getTracks(albumID: String, completion: @escaping SpotifyCompletionHandler) {
        let parameters = ["limit" : "50"]
        
        let method = replace(placeholder: "id", inMethod: Methods.getAlbumTracks, value: albumID)
        
        _ = task(getMethod: method, parameters: parameters) { result, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result as? [String : AnyObject], let tracksData = result["items"] as? [[String : AnyObject]] else {
                print("bad data structure")
                return
            }
        
            completion(tracksData as AnyObject?, nil)
        }
    }
}
