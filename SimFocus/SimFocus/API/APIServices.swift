import Foundation
import Alamofire

// MARK: Global Variable
let baseUrl = ""

// MARK: Enum class APIUrls
enum APIUrls {
    case login
}

// MARK: Enum class UrlEncoding
enum UrlEncoding {
    
    // MARK: Create URL Functions
    static func createUrl(url: APIUrls, pathComponent: String = "") -> String {
        switch url {
        case .login:
            return "https://2319-14-99-102-226.ngrok.io/api/login"
        }
    }
    
    // MARK: URL Encoding Functions
    static func urlEncoding(url: APIUrls) -> ParameterEncoding {
        switch url {
        case .login:
            return URLEncoding.default
        }
    }
    
    // MARK: URL Method Functions
    static func urlMethod(url: APIUrls) -> HTTPMethod {
        switch url {
        case .login:
            return .post
        }
    }
    
    // MARK: Response Code Functions
    static func responseCode(url: APIUrls) -> Int {
        switch url {
        case .login:
            return 200
        }
    }
    
}
