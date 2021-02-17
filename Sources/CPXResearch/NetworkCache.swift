//
//  NetworkCache.swift
//  
//
//  Created by Daniel Fredrich on 15.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit

final class NetworkCache {
    private var cache = NSCache<NSString, NSData>()

    func put<T: Codable>(_ model: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(model) as NSData
            cache.setObject(data, forKey: key as NSString)
        } catch {
            print("Error storing \(model) for key \(key)")
        }
    }

    func retrieve<T: Codable>(forKey key: String) -> T? {
        do {
            if let data = cache.object(forKey: key as NSString) {
                let model = try JSONDecoder().decode(T.self, from: data as Data)
                return model
            }
        } catch {
            print("Error retrieving data for key \(key)")
        }

        return nil
    }

    func clear() {
        cache.removeAllObjects()
    }
}

#endif
