import Foundation

public struct binarysearchtree<T: Comparable> {
    public typealias Node = binarytree<T>.Node
    
    public enum TraversePolicy {
        case Preoerder
        case Inorder
        case Postorder
    }
    
    public var lrCount = 0
    public var rrCount = 0
    public var lrrCount = 0
    public var rlrCount = 0
    
    private var _innerTree = binarytree<T>(root: nil)
    
    private var root: Node? {
        get {
            return self._innerTree.root
        }
        set {
            self._innerTree.root = newValue
        }
    }
    
    private var balanceFactor: Int {
        return self.root?.balanceFactor ?? -1
    }
    
    private var isBalance: Bool {
        return abs(self.balanceFactor) < 2
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
        var inserted = current
        while true {
            if value < current.value {
                guard let _ = current.left else {
                    let node = Node(value: value)
                    current.addLeft(node)
                    inserted = node
                    break
                }
                current = current.left!
            } else {
                guard let _ = current.right else {
                    let node = Node(value: value)
                    current.addRight(node)
                    inserted = node
                    break
                }
                current = current.right!
            }
        }
        
        if !self.isBalance {
            self.root = balance(node: self.root!)
        }
        
        assert(self.isBalance, "after insert value: \(value), bst is not balance!!!")
        
        return inserted
    }
    
    //
    // MARK: - remove element
    //
    @discardableResult
    public mutating func remove(value: T) -> Node? {
        let removed = remove(value: value, from: self.root)
        if removed != nil && !self.isBalance {
            self.root = balance(node: self.root!)
        }
        return removed
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
    
    private mutating func balance(node: Node) -> Node {
        var newNode = node
        switch node.balanceFactor {
        case -2:
            if let right = node.right, right.balanceFactor == 1 {
                newNode = rightLeftRotation(node: node)
                self.rlrCount += 1
                print("ritht-left rotation +1")
            } else {
                newNode = leftRotation(node: node)
                self.lrCount += 1
                print("left rotation +1")
            }
            break
        case 2:
            if let left = node.left, left.balanceFactor == -1 {
                newNode = leftRightRotation(node: node)
                self.lrrCount += 1
                print("left-right rotation +1")
            } else {
                newNode = rightRotation(node: node)
                self.rrCount += 1
                print("right rotation +1")
            }
            break
        default:
            break
        }
        
        return newNode
    }
    
    private func leftRotation(node: Node) -> Node {
        guard let povit = node.right else {
            return node
        }
        node.removeRight() // disconnect povit
        let povitLeftChild = povit.removeLeft() // disconnet povit left child
        node.addRight(povitLeftChild) // connect povit left to node right
        povit.addLeft(node) // connect node to povit left
        return povit
    }
    
    private func rightRotation(node: Node) -> Node {
        guard let povit = node.left else {
            return node
        }
        
        node.removeLeft()
        let povitRightChild = povit.removeRight()
        node.addLeft(povitRightChild)
        povit.addRight(node)
        return povit
    }
    
    private func leftRightRotation(node: Node) -> Node {
        guard let left = node.left,
            let _  = left.right else {
                return node
        }
        node.removeLeft()
        let newLeft = leftRotation(node: left)
        node.addLeft(newLeft)
        return rightRotation(node: node)
    }
    
    private func rightLeftRotation(node: Node) -> Node {
        guard let right = node.right,
            let _ = right.left else {
                return node
        }
        node.removeRight()
        let newRight = rightRotation(node: right)
        node.addRight(newRight)
        return leftRotation(node: node)
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
    
    public var balanceFactor: Int {
        return (self.left?.height ?? -1) - (self.right?.height ?? -1)
    }
}

//var testTree: binarysearchtree<Int> = [5,1,3,4,2,6,9,7,8,10]
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//print("in order traverse:")
//testTree.traverse(operation: { (value, stop) in
//    print(value)
//}, policy: .Inorder)
//
//let node_11 = testTree.insert(11)
//print("\n\nafter insert: \(node_11)(parent:\(node_11.parent!))")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 2)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 3)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 9)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 5)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("in order traverse:")
//testTree.traverse(operation: { (value, stop) in
//    print(value)
//}, policy: .Inorder)
//
//let unbanlanceTree: binarysearchtree<Int> = [1,2,3,4,5,6,7,8,9,10]
//print("unbalance tree:\n \(unbanlanceTree)")
//print("unbalance tree contain 6 ? : \(unbanlanceTree.contain(6))")
//print("unbalance tree contain 11 ? : \(unbanlanceTree.contain(11))")
//
//let pow2 = unbanlanceTree.map {$0 * $0 }

print("\n\n---------- AVL Tree -----------")

func generateRandomNumbers(count: Int, min: Int, max: Int) -> [Int] {
    var numbers = [Int]()
    
    for _ in 0..<count {
        numbers.append(Int.random(in: min...max))
    }
    
    return numbers
}

var balanceTree = binarysearchtree<Int>()
var numbers =  generateRandomNumbers(count: 50, min: 0, max: 100)
numbers = [Int](Set(numbers))

print("numbers: \(numbers)")
numbers.forEach { (value) in
    balanceTree.insert(value)
    print("after insert \(value), balance tree: \n\(balanceTree)")
}

print("lefr rotattion count: \(balanceTree.lrCount)")
print("right rotattion count: \(balanceTree.rrCount)")
print("left-right rotattion count: \(balanceTree.lrrCount)")
print("right-lefr rotattion count: \(balanceTree.rlrCount)")

