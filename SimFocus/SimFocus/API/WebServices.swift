import Foundation
import Alamofire

class WebServices {
    
    //Private Init used Because We not able to make Object of this Class
    private init(){}
    
    static let dictionary = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    // MARK: AlamofireWebServices Request Function
    private static func request<T: Decodable>(typeT: T.Type, url: URL, apiUrl: APIUrls, perameters: [String: Any]?, completion: @escaping (T?, Int) -> Void, error: @escaping (String, Int) -> Void) {
        let h = HTTPHeaders(dictionary)
        AF.request(url, method: UrlEncoding.urlMethod(url: apiUrl), parameters: perameters, encoding: UrlEncoding.urlEncoding(url: apiUrl), headers: h, interceptor: nil, requestModifier: nil).response { response in
            switch response.result {
            case .success(let data):
                guard let responceCode = response.response?.statusCode else {
                    return
                }
                if(responceCode == UrlEncoding.responseCode(url: apiUrl)) {
                    print(responceCode)
                    if let responseData = data {
                        do {
                            guard let jsonData = try JSONDecoder().decode(T?.self, from: responseData) else { return }
                            completion(jsonData, responceCode)
                        } catch (let errorMessage) {
                            error("Not Able to Convert JSON Data \(errorMessage).", responceCode)
                        }
                    } else {
                        completion(nil, responceCode)
                    }
                } else {
                    error("Response Code Wrong.", responceCode)
                }
                break
            case .failure(let errorMessage):
                error("Request Failure \(errorMessage).", 0)
            }
        }
    }
    
    
    // MARK: getLogin()
    public static func getLogin(data: [String: Any], result: @escaping (String) -> Void) {
        guard let url = URL(string: "\(UrlEncoding.createUrl(url: .login))") else {
            return
        }
        self.request(typeT: MessageClass.self, url: url, apiUrl: .login, perameters: data, completion: {responseData, code in
            if let userData = responseData {
                result("UserAdded")
            } else {
                result("Response Code: \(code)")
            }
        }, error: { message, code in
            result("Error: \(message) \(code)")
        })
    }
    
    // MARK: setSignUp()
    public static func setSignUp(data: [String: Any], result: @escaping (String) -> Void) {
        guard let url = URL(string: "\(UrlEncoding.createUrl(url: .signup))") else {
            return
        }
        self.request(typeT: MessageClass.self, url: url, apiUrl: .signup, perameters: data, completion: {responseData, code in
            if let userData = responseData {
                result("UserAdded")
            } else {
                result("Response Code: \(code)")
            }
        }, error: { message, code in
            result("Error: \(message) \(code)")
        })
    }
    
    // MARK: setSignUp()
    public static func checkEmail(data: [String: Any], complition: @escaping (Int) -> Void, error: @escaping (String, Int) -> Void) {
        guard let url = URL(string: "\(UrlEncoding.createUrl(url: .signup))") else {
            return
        }
        self.request(typeT: EmptyData.self, url: url, apiUrl: .signup, perameters: data, completion: {responseData, code in
            complition(code)
        }, error: {message, code in
            error("\(code) Error: \(message)", code)
        })
    }
    
}
