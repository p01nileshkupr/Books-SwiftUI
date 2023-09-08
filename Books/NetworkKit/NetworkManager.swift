//
//  NetworkManager.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

final actor NetworkManager {
    
    // MARK: - Properties

    static let sharedNetworkManager = NetworkManager()
    private let timeOutInterval: Double = RequestConfig.TIMEOUT

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        config.timeoutIntervalForResource = TimeInterval(timeOutInterval)
        return URLSession(configuration: config)
    }()
    
    //MARK: - init
    
    private init() {}
    
    // MARK: - Methods
    
    // A method to handle multiple web-service calls with async await
    func fetchData<T>(resource: HTTPRequestResource<T>) async -> Result<T, NetworkError> {
        let fullUrlPath = EnvironmentConfig.baseURL + resource.urlPath
        guard let url = URL(string: fullUrlPath) else { return .failure(.urlfailure) }
        
        var request = URLRequest(url: url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [
            HTTPRequestHeader.content_type_key: HTTPRequestHeader.content_type_value,
        ]

        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpresponse = response as? HTTPURLResponse else { return .failure(.noresponse) }

            if httpresponse.type == .success {
                #if DEBUG
                    let string = String(data: data, encoding: .utf8)
                    print(string as Any)
                #endif
                return .success(resource.parse(data))
            } else {
                return .failure(.requestfailed)
            }
        } catch {
            return .failure(.noresponse)
        }
    }
}
