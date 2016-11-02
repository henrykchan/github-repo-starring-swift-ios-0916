//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(_ completion: @escaping ([Any]) -> ()) {
        let urlString = "https://api.github.com/repositories?client_id=\(theSecrets.clientID)&client_secret=\(theSecrets.clientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(fullName:String, completion: @escaping (Bool) -> ()){
        
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(theSecrets.token)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        
        guard let unwrappedURL = url else {fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {return}
            
            if httpResponse.statusCode == 204 {
                completion(true)
            }
                
            else if httpResponse.statusCode == 404 {
                completion(false)
            }
        }
        task.resume()
    }
    
    
    class func starRepository(named:String, completion: @escaping () -> ()) {
        
        
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(theSecrets.token)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "PUT"
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        let task = session.dataTask(with: request) { (data, response, error) in
            
            completion()
        }
        task.resume()
    }
    
    
    
    class func unstarRepository(named:String, completion: @escaping () -> ()) {
        
        
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(theSecrets.token)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "Delete"
        let task = session.dataTask(with: request) { (data, response, error) in
            
            completion()
        }
        task.resume()
    }
    
}

