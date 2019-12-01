import Foundation

public struct queue<T> {
    private var enqueueElements:stack<T>
    private var dequeueElements:stack<T>

    public init() {
        self.enqueueElements = stack<T>()
        self.dequeueElements = stack<T>()
    }
    
    public init(_ elements: [T]) {
        self.init()
        self.enqueueElements = stack<T>(elements)
    }
    
    public var isEmpty: Bool {
        return self.dequeueElements.isEmpty && self.enqueueElements.isEmpty
    }
    
    public var count: Int {
        return self.dequeueElements.count + self.enqueueElements.count
    }
    
    public mutating func enqueue(_ element: T) {
        self.enqueueElements.push(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        guard !self.isEmpty else {
            return nil
        }
        
        if self.dequeueElements.isEmpty {
            self.dequeueElements = self.enqueueElements.reversed()
            self.enqueueElements.removeAll()
        }
        return dequeueElements.pop()
    }
    
    public var first: T? {
        guard !self.isEmpty else {
            return nil
        }
        return self.dequeueElements.isEmpty ? self.enqueueElements.buttom : self.dequeueElements.top
    }
    
    public var last: T? {
        guard !self.isEmpty else {
            return nil
        }
        return self.enqueueElements.isEmpty ? self.dequeueElements.buttom : self.enqueueElements.top
    }
}

extension queue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

extension queue: CustomStringConvertible {
    public var description: String {
        let desc = String(describing: self.dequeueElements.reversed()) + String(describing: self.enqueueElements.reversed())
        return desc
    }
}



extension stack {
    public func combined(_ other: stack<T>) -> stack<T> {
        var combinedStack = self
        var reversedOther = other.reversed()
        while !reversedOther.isEmpty {
            combinedStack.push(reversedOther.pop()!)
        }
        return combinedStack
    }
}
