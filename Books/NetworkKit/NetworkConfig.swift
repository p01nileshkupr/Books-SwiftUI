//
//  NetworkConfig.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

//MARK: - TypeAlias

typealias NetworkResponseType = NetworkConfig.ResponseType
typealias NetworkResponseCode = NetworkConfig.ResponseCode
typealias NetworkError = NetworkConfig.NetworkKitError
typealias NetworkServiceState = NetworkConfig.ServiceState

typealias HTTPRequestMethod = RequestConfig.Method
typealias HTTPRequestHeader = RequestConfig.Header
typealias HTTPRequestResource = RequestConfig.Resource

//MARK: - Network Config

struct EnvironmentConfig {
    private enum Keys {
        static let baseURL = "BASE_URL"
    }
    
    // Get the BASE_URL
    static let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.baseURL
        ) as? String else {
            fatalError("BASE_URL not found")
        }
        return baseURLProperty
    }()
}

//MARK: - Network Config

struct NetworkConfig {
    enum NetworkKitError: Error {
        case noresponse
        case parsingfailed
        case requestfailed
        case urlfailure
        case nodata
        case cachingFailed
    }
    
    enum ResponseType: Error {
        /// - informational: This class of status code indicates a provisional response, consisting only of the Status-Line and optional headers, and is terminated by an empty line.
        case informational
        /// - success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
        case success
        /// - redirection: This class of status code indicates the client must take additional action to complete the request.
        case redirection
        /// - clientError: This class of status code is intended for situations in which the client seems to have erred.
        case clientError
        /// - serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
        case serverError
        /// - undefined: The class of the status code cannot be resolved.
        case undefined
    }

    enum ResponseCode: Int, Error {
        // 100 Informational
        case Continue = 100
        case SwitchingProtocols
        case Processing
        // 200 Success
        case OK = 200
        case Created
        case Accepted
        case NonAuthoritativeInformation
        case NoContent
        case ResetContent
        case PartialContent
        case MultiStatus
        case AlreadyReported
        case IMUsed = 226
        // 300 Redirection
        case MultipleChoices = 300
        case MovedPermanently
        case Found
        case SeeOther
        case NotModified
        case UseProxy
        case SwitchProxy
        case TemporaryRedirect
        case PermanentRedirect
        // 400 Client Error
        case BadRequest = 400
        case Unauthorized
        case PaymentRequired
        case Forbidden
        case NotFound
        case MethodNotAllowed
        case NotAcceptable
        case ProxyAuthenticationRequired
        case RequestTimeout
        case Conflict
        case Gone
        case LengthRequired
        case PreconditionFailed
        case PayloadTooLarge
        case URITooLong
        case UnsupportedMediaType
        case RangeNotSatisfiable
        case ExpectationFailed
        case ImATeapot
        case MisdirectedRequest = 421
        case UnprocessableEntity
        case Locked
        case FailedDependency
        case UpgradeRequired = 426
        case PreconditionRequired = 428
        case TooManyRequests
        case RequestHeaderFieldsTooLarge = 431
        case UnavailableForLegalReasons = 451
        // 500 Server Error
        case InternalServerError = 500
        case NotImplemented
        case BadGateway
        case ServiceUnavailable
        case GatewayTimeout
        case HTTPVersionNotSupported
        case VariantAlsoNegotiates
        case InsufficientStorage
        case LoopDetected
        case NotExtended = 510
        case NetworkAuthenticationRequired
        case Unknown = -1

        /// The class (or group) which the status code belongs to.
        var responseType: ResponseType {
            
            switch self.rawValue {
                    
                case 100..<200:
                    return .informational
                    
                case 200..<300:
                    return .success
                    
                case 300..<400:
                    return .redirection
                    
                case 400..<500:
                    return .clientError
                    
                case 500..<600:
                    return .serverError
                    
                default:
                    return .undefined
                    
            }
        }
    }
    
    enum ServiceState {
        case unknown
        case notyetstarted
        case inprogress
        case failed
        case succeed
    }
}

//MARK: - HTTP Request Config

struct RequestConfig {
    
    struct Resource<T>{
        let urlPath: String
        let method: HTTPRequestMethod
        let body: Data?
        let parse: (Data) -> T
        
        init(urlPath: String = "",
             method: HTTPRequestMethod,
             body: Data? = nil,
             parse: @escaping (Data) -> T) {

            self.urlPath = urlPath
            self.method = method
            self.body = body
            self.parse = parse
        }
    }
    
    static let TIMEOUT: Double = 60
    
    /// A structure which keeps web-service request's keys
    enum Header {
        static let content_type_key = "Content-Type"
        static let content_type_value = "application/json"
        static let api_key = "API_KEY"
        static let user_agent_key = "User-Agent"
        
        static let apiKeyValue: String = {
            guard let rapidAPIKey = Bundle.main.object(
                forInfoDictionaryKey: Header.api_key
            ) as? String else {
                fatalError("API_KEY not found")
            }
            return rapidAPIKey
        }()
    }
    
    enum Method: String, Codable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}

//MARK: - HTTPURLResponse

extension HTTPURLResponse {

    var type: NetworkResponseType? {
        return NetworkResponseCode(rawValue: statusCode)?.responseType
    }
    
    var code: NetworkResponseCode {
        return NetworkResponseCode(rawValue: statusCode) ?? .Unknown
    }
}
