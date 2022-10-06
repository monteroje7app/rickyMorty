//
//  Constants.swift
//  ricky
//
//  Created by Jose Montero on 3/10/22.
//

import Foundation

final class Constants {

struct K {
    struct ProductionServer {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    struct APIParameterKey {
        static let password = ""
        static let email = ""
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum Endopint: String {
    case characters = "/character"
    case episodes = "/episode"
}

    
}
