import Foundation


public class trie<CollectionType: Collection> where CollectionType.Element:Hashable {
    typealias ElementType = CollectionType.Element
    private class Node {
        public var element: ElementType?
        public weak var parent: Node?
        public var children = [ElementType:Node]()
        public var isTermining = false
        
        init(element: ElementType? = nil, parent: Node? = nil) {
            self.element = element
            self.parent = parent
        }
    }
    
    private var root = Node()
    private(set) var count: Int = 0
    public var isEmpty: Bool {
        return self.count == 0
    }
    
    public func insert(_ collection: CollectionType) {
        var node = self.root
        collection.forEach { (e) in
            if node.children[e] == nil {
                node.children[e] = Node(element: e, parent: node)
            }
            node = node.children[e]!
        }
        node.isTermining = true
        self.count += 1
    }
    
    public func contain(_ collection: CollectionType) -> Bool {
        guard let node = node(macth: collection),
            node.isTermining else {
                return false
        }
        return true
    }
    
    public func remove(_ collection: CollectionType) -> Bool {
        return false
    }
    
    public func collections(match prefix: CollectionType) -> [CollectionType] {
        return []
    }
}

extension trie {
    private func node(macth prefix: CollectionType) -> Node? {
        var node = self.root
        for e in prefix {
            guard let child = node.children[e] else {
                return nil
            }
            node = child
        }
        return node
    }
}



var commonWrods = trie<String>()
commonWrods.insert("cut")
commonWrods.insert("cute")
print("commonWords contain \"cut\": \(commonWrods.contain("cut"))")
print("commonWords contain \"cute\": \(commonWrods.contain("cute"))")
print("commonWords contain \"cub\": \(commonWrods.contain("cub"))")
