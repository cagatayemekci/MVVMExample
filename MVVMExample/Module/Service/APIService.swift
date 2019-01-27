//
//  APIService.swift
//  MVVMExample
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import Foundation
import Alamofire


enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case jsonParse = "json parse error"
}

protocol APIServiceProtocol {
    func fetchToDoList ( complete: @escaping ( _ success: Bool, _ photos: [ToDoModel], _ error: APIError? )->() )
}

class APIService:APIServiceProtocol{
    
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let authToken = UserDefaults.standard.string(forKey: "auth_token") {
            headers["Authorization"] = "Token" + " " + authToken
        }
        return headers
    }
    
    func fetchToDoList ( complete: @escaping ( _ success: Bool, _ photos: [ToDoModel], _ error: APIError? )->() ){
        let todosEndpoint: String = "https://jsonplaceholder.typicode.com/todos/"
        Alamofire.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
            .responseData { response in
                guard let data  = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    let todomodels =  try decoder.decode([ToDoModel].self, from:data )
                    complete(true,todomodels,nil)
                    
                }catch _{
                    complete(false,[], .jsonParse)
                }
        }
    }
}
