//
//  SpotifyClient.swift
//  Albumzor
//
//  Created by Peter Cerhan on 3/12/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//

import Foundation

class SpotifyClient {
    
    var session = URLSession.shared
    
    
    func task(getMethod method: String, parameters: [String : AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, method: method))
        
        return(task(request: request as URLRequest, completionHandler: completionHandler))
    }
    
    
    
    func task(request: URLRequest, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "Parse Client", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
//            
//            let a = String(data: data, encoding: String.Encoding.utf8)
//            print("returned: \(a)")
//            
            self.parseJSONData(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    private func parseJSONData(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
        }
        
        completionHandler(parsedResult, nil)
    }
    
    private func urlFromParameters(_ parameters: [String:AnyObject], method: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath + method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK:- Shared Instance
    
    class func sharedInstance() -> SpotifyClient {
        struct Singleton {
            static var sharedInstance = SpotifyClient()
        }
        return Singleton.sharedInstance
    }
}
