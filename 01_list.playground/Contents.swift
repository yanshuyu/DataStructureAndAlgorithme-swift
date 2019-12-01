import Foundation



public struct forwardlist<T> {
    private var head: Node<T>?
    private var tail: Node<T>?
    private(set) public var count: Int
    
 
    public init(values: [T]) {
        self.count = 0
        values.forEach { (val) in
            append(val)
        }
    }
    
     public init() {
        self.head = nil
        self.tail = nil
        self.count = 0
    }
    
    //
    // MARK: - list statue
    //
    public var isEmpty: Bool {
        return self.head == nil && self.tail == nil && self.count == 0
    }
    

    //
    // MARK: - add element operation
    //
    @discardableResult
    public mutating func push(_ value: T) -> Node<T> {
        copyOnWrite()
        let newHead = Node(value: value)
        newHead.next = self.head
        if self.isEmpty {
            self.tail = newHead
        }
        self.head = newHead
        self.count += 1
        return newHead
    }
    
    @discardableResult
    public mutating func append(_ value: T) -> Node<T> {
        copyOnWrite()
        if self.isEmpty {
            return push(value)
        }
        
        let newTail = Node(value: value)
        self.tail?.next = newTail
        self.tail = newTail
        self.count += 1
        return newTail
    }
    
    @discardableResult
    public mutating func insert(value: T, after index: Index) -> Node<T>? {
        guard let _ = index.node else {
            return nil
        }
        
        var oldHead = self.head
        var realIdx = index
        let cow = copyOnWrite()
        if cow {
            var oldIdx = Index(node: oldHead)
            var newIdx = self.startIndex
            while oldIdx != index {
                oldIdx = self.index(after: oldIdx)
                newIdx = self.index(after: newIdx)
            }
            realIdx = newIdx
        }
        
        oldHead = nil
        
        guard let node = realIdx.node else {
            return nil
        }
        
        if node === self.tail {
            return append(value)
        }
        
        let newNode = Node(value: value)
        newNode.next = node.next
        node.next = newNode
        self.count += 1
        return newNode
    }
    
    //
    // MARK: - remove element operation
    //
    @discardableResult
    public mutating func pop() -> T? {
        copyOnWrite()
        let popedNode = self.head
        self.head = self.head?.next
        if self.count == 1 {
            self.head = nil
            self.tail = nil
        }
        self.count -= 1
        return popedNode?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> T? {
        copyOnWrite()
        if self.isEmpty {
            return nil
        }
        
        if self.count == 1 {
            return pop()
        }
        
        guard let rmNode = self.tail,
            let prevNode = node(before: rmNode) else {
                return nil
        }
        prevNode.next = nil
        self.tail = prevNode
        self.count -= 1
        
        return rmNode.value
    }
    
    @discardableResult
    public mutating func remove(at index: Index) -> T? {
        guard let _ = index.node else {
            return nil
        }
        
        if index.node === self.head {
            return pop()
        }
        
        if index.node === self.tail {
            return removeLast()
        }
        
        var oldHead = self.head
        var realIdx = index
        let cow = copyOnWrite()
        if cow {
            var oldIdx = Index(node: oldHead)
            var newIdx = self.startIndex
            while oldIdx != index {
                oldIdx = self.index(after: oldIdx)
                newIdx = self.index(after: newIdx)
            }
            realIdx = newIdx
        }
        oldHead = nil
        
        guard let rmNode = realIdx.node,
            let prevNode = node(before: rmNode) else {
                return nil
        }
        prevNode.next = rmNode.next
        self.count -= 1
        
        return rmNode.value
    }
}

extension forwardlist: Collection {
    public struct Index: Comparable {
        public var node: Node<T>?
        
        public static func == (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case (let lNode?, let rNode?):
                return lNode.next === rNode.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        public static func < (lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            
            let nodes = sequence(first: lhs.node) {
                $0?.next
            }
            return nodes.contains {
                $0 === rhs.node
            }
        }
    }
    

    public var startIndex: forwardlist<T>.Index {
        return Index(node: self.head)
    }
    
    public var endIndex: forwardlist<T>.Index {
        return Index(node: self.tail?.next)
    }
    
    public func index(after i: forwardlist<T>.Index) -> forwardlist<T>.Index {
        return Index(node: i.node?.next)
    }
    
    public subscript(position: forwardlist<T>.Index) -> T {
        return position.node!.value
    }
}

extension forwardlist: CustomStringConvertible {
    public var description: String {
        if self.isEmpty {
            return "nil"
        }
        var desc = ""
        var node = self.head
        var idx = 0
        while node != nil {
            desc += String(describing: node!)
            if idx < self.count-1 {
                desc += " -> "
            }
            node = node!.next
            idx += 1
        }
        return desc
    }
}

//
// MARK: - helper
//
extension forwardlist {
    private func node(before node: Node<T>) -> Node<T>? {
        if self.isEmpty {
            return nil
        }
        var current = self.head
        while current != nil {
            if current!.next === node {
                return current
            }
            current = current!.next
        }
        
        return nil
    }
    
    @discardableResult
    private mutating func copyOnWrite() -> Bool {
        if self.isEmpty {
            return false
        }
        
        guard !isKnownUniquelyReferenced(&self.head) else {
            return false
        }
        
        var itr = self.head!
        var node = Node(value: itr.value)
        self.head = node
        self.count = 1
        while itr.next != nil {
            let nextNode = Node(value: itr.next!.value)
            node.next = nextNode
            node = nextNode
            self.count += 1
            itr = itr.next!
        }
        self.tail = node
        
        return true
    }
}








public struct list<T> {
    private var head: Node<T>?
    private var tail: Node<T>?
}

print("----------add element operation----------")
var myList = forwardlist<Int>(values: [1,2,3])
print("myList: \(myList)")
print("myList element count: \(myList.count)")

myList.push(-1)
myList.append(4)
print("after push -1, append 4, myList: \(myList)")
print("myList element count: \(myList.count)")

//myList.insert(value: 100, after: 2)
//myList.insert(value: 1000, after: 100)
let myList2 = myList
if let idxOfval_2 = myList.firstIndex(of: 2) {
    myList.insert(value: 100, after: idxOfval_2)
}
if let idxOfVal_1000 = myList.firstIndex(of: 1000) {
    myList.insert(value: 200, after: idxOfVal_1000)
}
print("after insert 100 after 2, insert 200 after 1000, myList: \(myList)")
print("myList element count: \(myList.count)")
print("myList2 : \(myList2)")
print("myList2 element count: \(myList2.count)")

print("\n\n")
print("-----------remove element operation----------")
var list_1 = forwardlist<Int>()
print("list_1: \(list_1)")
print("list_1 element count: \(list_1.count)")

list_1.push(100)
list_1.push(200)
list_1.push(300)
var list_2 = list_1
print("after push 100, 200, 300, list_1: \(list_1)")
print("list_1 element count: \(list_1.count)")
print("list_2: \(list_2)")
print("list_2 element count: \(list_2.count)")

if let idxOf_200 = list_1.firstIndex(of: 200) {
    list_1.remove(at: idxOf_200)
}
print("after remove 200, list_1: \(list_1)")
print("list_1 element count: \(list_1.count)")
print("list_2: \(list_2)")
print("list_2 element count: \(list_2.count)")

list_1.removeLast()
print("after remove last element, list_1: \(list_1)")
print("list_1 element count: \(list_1.count)")
print("list_2: \(list_2)")
print("list_2 element count: \(list_2.count)")

list_1.pop()
print("after pop element, list_1: \(list_1)")
print("list_1 element count: \(list_1.count)")
print("list_2: \(list_2)")
print("list_2 element count: \(list_2.count)")

print("\n\n")
print("-----------collection protocol---------------")
list_2 = forwardlist<Int>(values: [10,20,30,40])
print("list_2: \(list_2)")
print("list_2 first element: \(list_2[list_2.startIndex])")
print("list_2 first 3 elements: \(Array(list_2.prefix(3)))")
print("list_2 last 3 elements: \(Array(list_2.suffix(3)))")
print("sum of list_2: \(list_2.reduce(0, +))")
let map_list_2 = list_2.map({$0 + 1})
print("add 1 to every element: \(map_list_2)")
var list_3 = list_2
list_3.append(50)
list_3.append(60)
print("list_2: \(list_2)")
print("list_3 (cow) : \(list_3)")
print("list_2 count: \(list_2.count)")
print("list_3 count: \(list_3.count)")
if let val = list_3.first(where: {$0 == 60}) {
    print("list_3 first val of 60: \(val)")
}



let test_1 = forwardlist<Int>()
var test_2 = test_1
test_2.append(8)
test_2.push(1)
print("\(test_1)")
print("\(test_2)")

