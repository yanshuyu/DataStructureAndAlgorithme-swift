import Foundation

public struct binarytree<T> {
    public class Node {
        public var value: T
        public weak var parent: Node?
        public var left: Node?
        public var right: Node?
        
        public init(value: T) {
            self.value = value
        }
        
        public var isRoot: Bool {
            return self.parent == nil
        }
        public var isLeaf: Bool {
            return self.left == nil && self.right == nil
        }
        public var count: Int {
            return (self.left?.count ?? 0) + 1 + (self.right?.count ?? 0)
        }
        
        @discardableResult
        public func addLeft(_ node: Node?) -> Node? {
            let oldLeft = self.left
            self.left = node
            node?.parent = self
            oldLeft?.parent = nil
            return oldLeft
        }
        
        @discardableResult
        public func addRight(_ node: Node?) -> Node? {
            let oldRight = self.right
            self.right = node
            node?.parent = self
            oldRight?.parent = nil
            return oldRight
        }
        
        public func removeLeft() {
            addLeft(nil)
        }
        
        public func removeRight() {
            addRight(nil)
        }
        
        public func removeChildrens() {
            removeLeft()
            removeRight()
        }
    }
    
    
    public var root: Node?
    public var isEmpty: Bool {
        return self.root == nil
    }
    public var count: Int {
        guard let root = self.root else {
            return 0
        }
        
        return root.count
    }
    
    public init(root: Node?) {
        self.root = root
    }
    
    public func traversePreorder(_ operation: (T, inout Bool)->Void ) {        var stop = false
        traversPreorder(from: self.root, operation: operation, stop: &stop)
    }
    
    public func traverseInorder(_ operation: (T, inout Bool)->Void ) {
        var stop = false
        traverseInorder(from: self.root, operation: operation, stop: &stop)
    }
    
    public func traversePostorder(_ operation: (T, inout Bool)->Void ) {
        var stop = false
        traversePostorder(from: self.root, operation: operation, stop: &stop)
    }
}

extension binarytree {
    private func traversPreorder(from node: Node?, operation: (T, inout Bool)->Void, stop: inout Bool) {
        guard let _ = node else {
            return
        }
        
        if stop {
            return
        }
        operation(node!.value, &stop)

        traversPreorder(from: node!.left, operation: operation, stop: &stop)
        traversPreorder(from: node!.right, operation: operation, stop: &stop)
    }
    
    private func traverseInorder(from node: Node?, operation: (T, inout Bool)->Void, stop: inout Bool) {
        guard let _ = node else {
            return
        }
        
        traverseInorder(from: node!.left, operation: operation, stop: &stop)
       
        if stop {
            return
        }
        operation(node!.value, &stop)

        traverseInorder(from: node!.right, operation: operation, stop: &stop)
    }
    
    private func traversePostorder(from node: Node?, operation: (T, inout Bool)->Void, stop: inout Bool) {
        guard let _ = node else {
            return
        }
        
        traversePostorder(from: node!.left, operation: operation, stop: &stop)
        traversePostorder(from: node!.right, operation: operation, stop: &stop)
        
        if stop {
            return
        }
        operation(node!.value, &stop)
    }
}

extension binarytree: CustomStringConvertible {
    public var description: String {
        guard let node = self.root else {
            return "nil"
        }
        return String(describing: node)
    }
}


extension binarytree.Node: CustomStringConvertible {
    public var description: String {
        return diagram(from: self, top: "    ", root: "(root)", bottom: "    ")
    }
    
    private func diagram(from node: binarytree.Node?, top: String = "", root: String = "", bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        
        if node.left == nil && node.right == nil {
            return root + "\(node.value)\n"
        }
         
        return diagram(from: node.right, top: top + " ", root: top + "┌──", bottom: top + "│ ")
            + root + "\(node.value)\n" + diagram(from: node.left, top: bottom + "│ ", root: bottom + "└──", bottom: bottom + " ")
    }
}
