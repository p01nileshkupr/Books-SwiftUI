//
//  Codable+Extensions.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

//MARK: - Decodable

extension Decodable {
    
    func decode<T: Decodable>(from dictionary: [String : Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    static func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseModel = try decoder.decode(T.self, from: data)
            return responseModel
        } catch {
        #if DEBUG
            print(self, error.localizedDescription)
        #endif
            return nil
        }
    }
    
    static func decodedList<T: Decodable>(_ data: Data) -> [T] {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let list = try decoder.decode([T].self, from: data)
            return list
        } catch {
        #if DEBUG
            print(self, error.localizedDescription)
        #endif
            return []
        }
    }
}

//MARK: - Encodable

extension Encodable {
    static func encode<T: Encodable>(_ value: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(value)
            return jsonData
        } catch {
        #if DEBUG
            print(error.localizedDescription)
        #endif
            return nil
        }
    }
    
    static func jsonData(_ data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any]
            return jsonObject
        } catch {
            return nil
        }
    }
}
