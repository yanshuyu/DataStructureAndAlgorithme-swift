import Foundation

public class Node<T>: CustomStringConvertible {
    public var value: T
    public weak var prev: Node<T>?
    public var next: Node<T>?
    
    public var description: String {
        return String(describing: value)
    }
    
    public init(value: T, prev: Node<T>? = nil, next: Node<T>? = nil) {
        self.value = value
        self.prev = prev
        self.next = next
    }
}
