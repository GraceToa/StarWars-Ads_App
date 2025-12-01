//
//  CacheResponse.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

struct CachedResponse<Value> {
    let value: Value
    let isFromCache: Bool
}
