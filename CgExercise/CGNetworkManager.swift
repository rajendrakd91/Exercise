//
//  CGNetworkManager.swift
//  CgExercise
//
//  Created by Test User 1 on 11/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import Foundation
import UIKit


let feedUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts"


class CGNetworkManager: NSObject {
    
    typealias networkCompletionHandler = (_ anyObject:AnyObject?, _ errorMessage:String?) -> Void
    var completionHandler:networkCompletionHandler?

    
    func getFeeds(handler : @escaping networkCompletionHandler) -> Void {
        self.completionHandler = handler
        guard let url = URL(string: feedUrl) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                
            } else {
                guard let receivedData = data else{
                    return
                }
                let responseData = String(data: receivedData, encoding: .isoLatin1)
                if let modifiedData = responseData?.data(using: .utf8) {
                    do{
                        let convertedData = try JSONSerialization.jsonObject(with: modifiedData, options: [])
                        print(convertedData)
                        let array = self.parseJson(data: convertedData)
//                        self.completionHandler?(array,error?.localizedDescription)
                        handler(array, error?.localizedDescription)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJson(data: Any) -> NSMutableArray {
        let dataArray = NSMutableArray()
        guard let responseArray = (data as? NSDictionary)?.value(forKey: "rows") as? NSArray
        else{ return [] }
        for (_, element) in responseArray.enumerated() {
            let model = FactModel()
            guard let factObj = element as? NSDictionary else {
               return []
            }
            if let title = factObj.value(forKey: "title") as? String,  let desc = factObj.value(forKey: "description") as? String,let imgUrl = factObj.value(forKey: "imageHref") as? String{
                
                model.title = title
                model.descrip = desc
                model.imageHref = imgUrl
            }
            dataArray.add(model)
        }
        return dataArray
    }

}
