import Foundation

public struct tree<T> {
    public class Node {
        public var value: T
        public weak var parent: Node?
        public var childens = [Node]()
        
        init(value: T) {
            self.value = value
        }
        
        public func addChild(_ child: Node) {
            self.childens.append(child)
            child.parent = self
        }
    }
    
    public var root: Node?
    
    init(root: Node? = nil ) {
        self.root = root
    }
    
    public var isEmpty: Bool {
        return self.root == nil
    }
    
    
    // depth-first traverse
    public func depthFirstTraverse(operation: (T, inout Bool)->Void) {
        guard !self.isEmpty else {
            return
        }
        
        var stop = false
        //depthFirstTraverse(form: self.root, operation: operation, stop: &stop)
        var traverseStack = stack<Node>()
        traverseStack.push(self.root!)
        while !traverseStack.isEmpty {
            let node = traverseStack.pop()!
            operation(node.value, &stop)
            if stop {
                return
            }
            node.childens.reversed().forEach { (child) in
                traverseStack.push(child)
            }
        }
    }
    
    // breadth-first traverse
    public func breadthFirstTraverse(operation: (T, inout Bool)->Void ) {
        guard !self.isEmpty else {
            return
        }
        var stop = false
        var traverseQueue = queue<Node>()
        traverseQueue.enqueue(self.root!)
        while !traverseQueue.isEmpty {
            let node = traverseQueue.dequeue()!
            operation(node.value, &stop)
            if stop {
                return
            }
            node.childens.forEach { (child) in
                traverseQueue.enqueue(child)
            }
        }
    }
}

extension tree {
    private func depthFirstTraverse(form node: Node?, operation: (T, inout Bool) -> Void, stop: inout Bool) {
        guard let node = node else {
            return
        }
        operation(node.value, &stop)
        if stop {
            return
        }
        node.childens.forEach { (node) in
            depthFirstTraverse(form: node, operation: operation, stop: &stop)
        }
    }
    
}


func buildTestTree() -> tree<Int> {
    let node_1 = tree<Int>.Node(value: 1)
    let node_2 = tree<Int>.Node(value: 2)
    let node_3 = tree<Int>.Node(value: 3)
    let node_4 = tree<Int>.Node(value: 4)
    let node_5 = tree<Int>.Node(value: 5)
    let node_6 = tree<Int>.Node(value: 6)
    let node_7 = tree<Int>.Node(value: 7)
    let node_8 = tree<Int>.Node(value: 8)
    
    
    node_2.addChild(node_5)
    node_2.addChild(node_6)
    
    node_1.addChild(node_2)
    node_1.addChild(node_3)
    node_1.addChild(node_4)
    
    node_6.addChild(node_7)
    
    node_4.addChild(node_8)
    
    return tree(root: node_1)
}

let testTree = buildTestTree()
print("test tree(bft): ")
testTree.breadthFirstTraverse { (value, stop) in
    print(value)
}

print("\n\n")
print("test tree(dft): ")
testTree.depthFirstTraverse { (value, stop) in
    print(value)
}
