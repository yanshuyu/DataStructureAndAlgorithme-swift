import Foundation

public struct stack<T> {
    private var elementStack: Array<T>
    
    public init(_ elements: [T]) {
        self.elementStack = elements
    }
    
    public init() {
        self.init([])
    }
    
    public var isEmpty: Bool {
        return self.elementStack.isEmpty
    }
    
    public var count: Int {
        return self.elementStack.count
    }
    
    public var top: T? {
        return self.elementStack.last
    }
    
    public var buttom: T? {
        return self.elementStack.first
    }
    
    public mutating func push(_ value: T) {
        self.elementStack.append(value)
    }
    
    public mutating func pop() -> T? {
        guard !self.isEmpty else {
            return nil
        }
        return self.elementStack.removeLast()
    }

    public func reversed() -> stack<T> {
        var reverseStack = stack<T>()
        reverseStack.elementStack = self.elementStack.reversed()
        return reverseStack
    }
    
    public mutating func removeAll() {
        self.elementStack.removeAll()
    }
}


extension stack: CustomStringConvertible {
    public var description: String {
        var desc = ""
        if !self.isEmpty {
            var idx = self.elementStack.count - 1
            while idx >= 0 {
                desc += "\n"
                desc += String(describing: self.elementStack[idx])
                idx -= 1
            }
        }
        return desc
    }
}

extension stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.elementStack = elements
    }
}
