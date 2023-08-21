import Foundation 
 
public enum HttpMethodEnum: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
}

public protocol ClientURLSessionDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, currentProgress: Float, currentProgressValue: Float)
}

@objcMembers
public class Client: NSObject {
    @objc
    public var api_key:String = ""
    @objc
    public var timeoutInterval: TimeInterval = 300
    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    @objc
    public var completionHandler: (@Sendable (Data?, URLResponse?, Error?) -> Void)?
    public var delegate: ClientURLSessionDelegate?
    
    public init(api_key:String = "") {
        self.api_key = api_key
        super.init()
    }
    
    public func uploadFile(url: URL, fileUrl: URL, httpMethod: HttpMethodEnum = .PUT) {
        var request = URLRequest(url: url)
        request.timeoutInterval = self.timeoutInterval
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .GET:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "apikey", value: self.api_key)]
            guard let urlWithQuery = components?.url else {
                fatalError("Invalid URL")
            }
            request = URLRequest(url: urlWithQuery)
        case .POST, .PUT:
            let postData = self.api_key.data(using: .utf8)
            request.httpBody = postData
        }
        
        let data = try? Data(contentsOf: fileUrl)
        debugPrint("data count:\(String(describing: data?.count))")
        let task = session.uploadTask(with: request, from: data)  { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            self.completionHandler?(data,response,error)
        }
        task.resume()
     }
    
}

extension Client: URLSessionDelegate,URLSessionTaskDelegate, UINavigationControllerDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let currentProgress = (totalBytesSent * 100) / totalBytesExpectedToSend
        let currentProgressValue = Float(Double(currentProgress) *  1 / 100.0)
        self.delegate?.urlSession(session, task: task, didSendBodyData: bytesSent, currentProgress: Float(currentProgress), currentProgressValue: currentProgressValue)
    }
    
}
 
