//
//  FirebaseFunctionsRepresentable.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 5/24/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import FirebaseFunctions
import Foundation

protocol FirebaseFunctionsRepresentable: Encodable {
    associatedtype Response: Codable
    
    static var functionName: String { get }
}

extension FirebaseFunctionsRepresentable {
    func call() async -> (Response?, Error?) {
        var dict: [String: Any] = [:]
        
        do {
            let pushData = try JSONEncoder().encode(self)
            dict = try JSONSerialization.jsonObject(with: pushData, options: []) as! [String: Any]
            
            let result = try await Functions.functions().httpsCallable(Self.functionName).call(dict)
            let returnData = try JSONSerialization.data(withJSONObject: result.data)
            
            let response = try JSONDecoder().decode(Response.self, from: returnData)
            
            return (response, nil)
        } catch {
            return (nil, error)
        }
    }
}
