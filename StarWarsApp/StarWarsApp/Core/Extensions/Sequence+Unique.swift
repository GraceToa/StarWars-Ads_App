//
//  Sequence+Unique.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

/// Returns a new array with duplicate elements removed,
/// preserving the original order of appearance.
extension Sequence {
    func uniqued<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
