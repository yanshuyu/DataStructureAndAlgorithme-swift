import Foundation


public struct PriorityQueue<T> where T:Comparable {
    public typealias Index = Heap<T>.Index
    
    private var heap: Heap<T>
    
    public var count: Int {
        return self.heap.count
    }
    public var isEmpty: Bool {
        return self.heap.isEmpty
    }
    
    public init(sort: @escaping (T,T)->Bool) {
        self.heap = Heap(comparer: sort)
    }
    
    public init(values: [T], sort: @escaping (T,T)->Bool) {
        self.init(sort: sort)
        values.forEach {
            enqueue($0)
        }
    }
    
    public mutating func enqueue(_ value: T) {
        self.heap.add(value)
    }
    
    public mutating func dequeue() -> T? {
        return self.heap.pop()
    }
    
    public func peek() -> T? {
        return self.heap.peek()
    }
    
    public func firstIndex(_ value: T) -> Index? {
        return self.heap.index(for: value)
    }
    
    public mutating func remove(at index: Index) -> T? {
        return self.heap.remove(at: index)
    }
}

extension PriorityQueue: CustomStringConvertible {
    public var description: String {
        var copy = self.heap
        var values = [T]()
        while !copy.isEmpty {
            values.append(copy.pop()!)
        }
        return String(describing: values)
    }
}
