//
//  TrafficDataProvider.swift
//  TrafficApp
//
//  Created by Umang Davessar on 2/12/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
 
 This API class returns the data provided by given URL
 Returns the Array with completion block
 Retuen Error with failure Blocks
 
 */

 // MARK:- API - GET TRAFFIC DETAILS 
class TrafficDataProvider
{
    
    var trafficDataArray = [[String: AnyObject]]()
    
    open func getTrafficDetails(success:@escaping (_ trafficdata: [[String: AnyObject]])-> Void, failure:@escaping (_ error: RZError?)-> Void) -> Void {

       let url = URL(string: "https://api.data.gov.sg/v1/transport/traffic-images")
       var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
                    
        Alamofire.request(urlRequest)
                .responseData { (response) in
        let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
        debugPrint(stringResponse)
                            
        var statusCode = 0
                            
        if(response.response != nil){
        statusCode = (response.response?.statusCode)!
                                
        }
                            
                            
        if (response.result.isSuccess) {
                                 
        if statusCode >= 200 && statusCode < 300 {
                                    
        do {
          if let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] {
        // try to read out a string array
          if let arry = json["items"] as? [[String:AnyObject]] {
          for dictionary in arry {
          let arrCamera =  dictionary["cameras"] as! Array<Any>
            
           for (index, element) in arrCamera.enumerated()
           {
             print(index)
             self.trafficDataArray.append(element as! [String : AnyObject])
           }
            success(self.trafficDataArray)
        }}
        }} catch {
          print(error)
        }
                                        
      }
        else if statusCode == 500 { // Handling internal server error
        print("Internal server error")
        failure(RZError(error: nil, customeMessage: response.error?.localizedDescription))
    }
        else if statusCode == 401 {
           // Unauthorized....
                                    
         failure(RZError(error: nil, customeMessage: "Unauthorized"))
       }
       else {
            failure(nil)
        }
                                
     }
       else {
        print("\(#function)::response.result.debugDescription->\(String(describing: response.error?.localizedDescription))")
            
         failure(RZError(error: response.error, customeMessage: response.error?.localizedDescription))
       }
      }
                    
                    
                
    }
        
       
}
