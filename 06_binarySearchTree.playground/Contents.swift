import Foundation

public struct binarysearchtree<T: Comparable> {
    public typealias Node = binarytree<T>.Node
    
    public enum TraversePolicy {
        case Preoerder
        case Inorder
        case Postorder
    }
    
    private var _innerTree = binarytree<T>(root: nil)
    
    private var root: Node? {
        get {
            return self._innerTree.root
        }
        set {
            self._innerTree.root = newValue
        }
    }
    
    public var isEmpty: Bool {
        return self._innerTree.isEmpty
    }
    
    public var count: Int {
        return self._innerTree.count
    }
    
    public var min: T? {
        return min(form: self.root)
    }
    
    public var max: T? {
        return max(from: self.root)
    }
    
    public init(values: [T]) {
        values.forEach { (value) in
            insert(value)
        }
    }
    
    //
    // MARK: - traverse
    //
    public func traverse(operation: (T, inout Bool)->Void, policy: TraversePolicy = .Inorder) {
        switch policy {
        case .Preoerder:
            self._innerTree.traversePreorder(operation)
            break
        case .Inorder:
            self._innerTree.traverseInorder(operation)
            break
        case .Postorder:
            self._innerTree.traversePostorder(operation)
            break
        }
    }
    
    public func map(_ operation: (T)->T ) -> [T] {
        var transformed = [T]()
        traverse(operation: { (value, stop) in
            transformed.append(operation(value))
        }, policy: .Inorder)
        return transformed
    }
    
    //
    // MARK: - insert element
    //
    @discardableResult
    public mutating func insert(_ value: T) -> Node {
        if self.isEmpty {
            self.root = Node(value: value)
            return self.root!
        }
        
        var current = self.root!
        while true {
            if value < current.value {
                guard let _ = current.left else {
                    let node = Node(value: value)
                    current.addLeft(node)
                    return node
                }
                current = current.left!
            } else {
                guard let _ = current.right else {
                    let node = Node(value: value)
                    current.addRight(node)
                    return node
                }
                current = current.right!
            }
        }
    }
    
    //
    // MARK: - remove element
    //
    @discardableResult
    public mutating func remove(value: T) -> Node? {
        return remove(value: value, from: self.root)
    }
    
    //
    // MARK: - search
    //
    public func contain(_ value: T) -> Bool {
        var found = false
        var node = self.root
        while node != nil {
            if node!.value == value {
                found = true
                break
            }
            node = value < node!.value ? node?.left : node?.right
        }
        return found
    }
}

extension binarysearchtree {
    private func min(form node: Node?) -> T? {
        guard let node = node else {
            return nil
        }
        
        var pos = node
        while pos.left != nil {
            pos = pos.left!
        }
        return pos.value
    }
    
    private func max(from node: Node?) -> T? {
        guard let node = node else {
            return nil
        }
        
        var pos = node
        while pos.right != nil {
            pos = pos.right!
        }
        return pos.value
    }
    
    private mutating func remove(value: T, from node: Node?) -> Node? {
        var pos = node
        while pos != nil {
            if pos!.value == value {
                return remove(node: pos!)
            }
            pos = value < pos!.value ? pos!.left : pos!.right
        }
        return nil
    }
    
    private mutating func remove(node: Node) -> Node {
        // removed node is leaf
        if node.isLeaf {
            if node.isLeftChild { // left child
                return node.parent!.removeLeft()!
            } else if node.isRightChild { // right child
                return node.parent!.removeRight()!
            } else { // root node
                assert(node.isRoot)
                self.root = nil
                return node
            }
        }

        // removed node has one right child only
        if node.left == nil {
            if node.isLeftChild {
                return node.parent!.addLeft(node.removeRight())!
            } else if node.isRightChild {
                return node.parent!.addRight(node.removeRight())!
            } else {
                assert(node.isRoot)
                self.root = node.removeRight()
                return node
            }
        }
        
        // removed node has one left child only
        if node.right == nil {
            if node.isLeftChild {
                return node.parent!.addLeft(node.removeLeft())!
            } else if node.isRightChild {
                return node.parent!.addRight(node.removeLeft())!
            } else {
                assert(node.isRoot)
                self.root = self.root?.removeLeft()
                return node
            }
        }
        
        // removed node has two childen
        node.value = min(form: node.right)!
        return remove(value: node.value, from: node.right)!
    }
}


extension binarysearchtree: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        elements.forEach { (value) in
            insert(value)
        }
    }
}

extension binarysearchtree: CustomStringConvertible {
    public var description: String {
        guard !self.isEmpty else {
            return "nil"
        }
        return self._innerTree.description
    }
}


extension binarytree.Node {
    public var isLeftChild: Bool {
        return self.parent?.left === self
    }
    
    public var isRightChild: Bool {
        return self.parent?.right === self
    }
}

var testTree: binarysearchtree<Int> = [5,1,3,4,2,6,9,7,8,10]
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
print("in order traverse:")
testTree.traverse(operation: { (value, stop) in
    print(value)
}, policy: .Inorder)

let node_11 = testTree.insert(11)
print("\n\nafter insert: \(node_11)(parent:\(node_11.parent!))")
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")

print("\n\nafter remove: \(testTree.remove(value: 2)!.value)")
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")

print("\n\nafter remove: \(testTree.remove(value: 3)!.value)")
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")

print("\n\nafter remove: \(testTree.remove(value: 9)!.value)")
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")

print("\n\nafter remove: \(testTree.remove(value: 5)!.value)")
print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")

print("in order traverse:")
testTree.traverse(operation: { (value, stop) in
    print(value)
}, policy: .Inorder)

let unbanlanceTree: binarysearchtree<Int> = [1,2,3,4,5,6,7,8,9,10]
print("unbalance tree:\n \(unbanlanceTree)")
print("unbalance tree contain 6 ? : \(unbanlanceTree.contain(6))")
print("unbalance tree contain 11 ? : \(unbanlanceTree.contain(11))")
let pow2 = unbanlanceTree.map {$0 * $0 }
print("^2 of unbalance tree: \(pow2)")
