import Foundation
import Alamofire

class WebServices {
    
    //Private Init used Because We not able to make Object of this Class
    private init(){}
    
    // MARK: AlamofireWebServices Request Function
    private static func request<T: Decodable>(typeT: T.Type, url: URL, apiUrl: APIUrls, perameters: [String: Any]?, completion: @escaping (T?, Int) -> Void, error: @escaping (String, Int) -> Void) {
        AF.request(url, method: UrlEncoding.urlMethod(url: apiUrl), parameters: perameters, encoding: UrlEncoding.urlEncoding(url: apiUrl), headers: nil, interceptor: nil, requestModifier: nil).response { response in
            switch response.result {
            case .success(let data):
                guard let responceCode = response.response?.statusCode else {
                    return
                }
                if(responceCode == UrlEncoding.responseCode(url: apiUrl)) {
                    if let responseData = data {
                        do {
                            guard let jsonData = try JSONDecoder().decode(T?.self, from: responseData) else { return }
                            completion(jsonData, responceCode)
                        } catch (let errorMessage) {
                            error("Not Able to Convert JSON Data \(errorMessage).", 0)
                        }
                    } else {
                        completion(nil, responceCode)
                    }
                } else {
                    error("\(responceCode) Data Not Found.", responceCode)
                }
                break
            case .failure(let errorMessage):
                error("Request Failure \(errorMessage).", 0)
            }
        }
    }
    
    
    // MARK: User Detail Functions
    public static func getLogin() {
        guard let url = URL(string: "\(UrlEncoding.createUrl(url: .login))") else {
            return
        }
        let data  = ["email": "brijeshbarasiya44@gmail.com", "password": "885566"]
        self.request(typeT: LoginDataClass.self, url: url, apiUrl: .login, perameters: data, completion: {responseData, code in
            if let userData = responseData {
                print(userData.message)
            } else {
                print(code)
            }
        }, error: { message, code in
            print("Error: \(message)")
        })
    }
    
}
