//
//  Region.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/26/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI

struct Region: Identifiable, Decodable, Equatable {
    var id: String = UUID().uuidString
    
    var code: String
    var dialCode: UInt64
    var name: String?
    let flagEmoji: String
    
    enum CodingKeys: CodingKey {
        case code, dialCode, name
    }
    
    init(code: String, dialCode: UInt64, name: String? = nil) {
        self.code = code
        self.dialCode = dialCode
        self.name = name
        
        self.flagEmoji = code
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.dialCode = try container.decode(UInt64.self, forKey: .dialCode)
        self.code = try container.decode(String.self, forKey: .code)
        
        self.flagEmoji = code
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    static func ==(lhs: Region, rhs: Region) -> Bool {
        lhs.name == rhs.name
    }
}
