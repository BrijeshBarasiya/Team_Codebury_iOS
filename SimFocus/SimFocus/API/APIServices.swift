import Foundation
import Alamofire

// MARK: Global Variable
let baseUrl = ""

// MARK: Enum class APIUrls
enum APIUrls {
    case login
    case signup
    case checkEmail
}

// MARK: Enum class UrlEncoding
enum UrlEncoding {
    
    // MARK: Create URL Functions
    static func createUrl(url: APIUrls, pathComponent: String = "") -> String {
        switch url {
        case .login:
            return "https://5f17-14-99-102-226.ngrok.io/api/login"
        case .signup:
            return "https://5f17-14-99-102-226.ngrok.io/api/email-register"
        case .checkEmail:
            return "https://5f17-14-99-102-226.ngrok.io/api/email-checker"
        }
    }
    
    // MARK: URL Encoding Functions
    static func urlEncoding(url: APIUrls) -> ParameterEncoding {
        switch url {
        case .login, .signup:
            return URLEncoding.default
        case .checkEmail:
            return JSONEncoding.default
        }
    }
    
    // MARK: URL Method Functions
    static func urlMethod(url: APIUrls) -> HTTPMethod {
        switch url {
        case .login, .signup, .checkEmail:
            return .post
        }
    }
    
    // MARK: Response Code Functions
    static func responseCode(url: APIUrls) -> Int {
        switch url {
        case .login:
            return 200
        case .signup:
            return 201
        case .checkEmail:
            return 200
        }
    }
    
}
