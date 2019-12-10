import Foundation

public class Heap<ElementType:Comparable> {
    public typealias Index = Array<ElementType>.Index
    
    private var elements = [ElementType]()
    private var comparer: (ElementType, ElementType)->Bool
    
    public var count: Int {
        return self.elements.count
    }
    public var isEmpty: Bool {
        return self.elements.isEmpty
    }

    public init(comparer: @escaping (ElementType, ElementType)->Bool) {
        self.comparer = comparer
    }
    
    //
    // MARK: - return highest priority(min,max) element in heap
    //
    public func peek() -> ElementType? {
        return self.elements.first
    }
    
    //
    // MARK: - insert a element to heap
    //
    public func add(_ element: ElementType) {
        self.elements.append(element)
        shitUp(from: self.count-1)
    }
    
    //
    // MARK: - remove highest priority element from heap
    //
    public func pop() -> ElementType? {
        if self.isEmpty {
            return nil
        }
        
        self.elements.swapAt(0, self.count-1)
        defer {
            shitDown(from: 0)
        }
        return self.elements.removeLast()
    }
    
    //
    // MARK: - remove element at index
    //
    public func remove(at idx: Index) -> ElementType? {
        guard isValiedIndex(idx) else {
            return nil
        }
        
        self.elements.swapAt(idx, self.count-1)
        defer {
            shitDown(from: idx)
            shitUp(from: idx)
        }
        return self.elements.removeLast()
    }
    
    //
    // MARK: - index for element
    //
    public func index(for element: ElementType) -> Index? {
        if self.isEmpty {
            return nil
        }
        
        if comparer(element, self.elements.first!) {
            return nil
        }
        
        return search(element: element, from: 0)
    }
    
}

extension Heap {
    private func isValiedIndex(_ idx: Index) -> Bool {
        return idx >= 0 && idx < self.count
    }
    private func leftChildIndex(ofParentAt idx: Index) -> Index? {
        let pos = 2 * idx + 1
        return isValiedIndex(pos) ? pos : nil
    }
    
    private func rightChildIndex(ofParentAt idx: Index) -> Index? {
        let pos = 2 * idx + 2
        return isValiedIndex(pos) ? pos : nil
    }
    
    private func parentIndex(ofChildAt idx: Index) -> Index? {
        let pos = Int(floor((Float(idx) - 1)/2))
        return isValiedIndex(pos) ? pos : nil
    }
    
    private func shitUp(from idx: Index) {
        guard isValiedIndex(idx) else {
            return
        }
        
        var current = idx
        var parent = parentIndex(ofChildAt: current)
        while parent != nil {
            if comparer(self.elements[parent!], self.elements[current]) { // parent's priority is higgher than current
                break
            }
            self.elements.swapAt(current, parent!)
            current = parent!
            parent = parentIndex(ofChildAt: current)
        }
    }
    
    private func shitDown(from idx: Index) {
        var pos = idx
        while isValiedIndex(pos) {
            var candidater = pos
            if let leftIdx = leftChildIndex(ofParentAt: pos) {
                if comparer(self.elements[leftIdx], self.elements[candidater]) {
                    candidater = leftIdx
                }
            }
            
            if let rightIdx = rightChildIndex(ofParentAt: pos) {
                if comparer(self.elements[rightIdx], self.elements[candidater]) {
                    candidater = rightIdx
                }
            }
            
            if pos == candidater {
                break
            }
            
            self.elements.swapAt(pos, candidater)
            pos = candidater
        }
    }
    
    private func search(element: ElementType, from idx: Index) -> Index? {
        guard isValiedIndex(idx) else {
            return nil
        }
        
        if self.elements[idx] == element {
            return idx
        }
        
        var targexIdx: Index? = nil
        if let leftChildIdx = leftChildIndex(ofParentAt: idx) {
            targexIdx = search(element: element, from: leftChildIdx)
        }
        
        if let rightChildIdx = rightChildIndex(ofParentAt: idx),
            targexIdx == nil {
            targexIdx = search(element: element, from: rightChildIdx)
        }
        
        return targexIdx
    }
}


extension Heap: CustomStringConvertible {
    public var description: String {
        return diagram(from: self.elements.startIndex, top: "    ", root: "(root)", bottom: "    ")
    }
    
    private func diagram(from idx: Index?, top: String = "", root: String = "", bottom: String = "") -> String {
        guard let idx = idx, isValiedIndex(idx) else {
            return root + "nil\n"
        }
        
        let leftIndex = leftChildIndex(ofParentAt: idx)
        let rightIndex = rightChildIndex(ofParentAt: idx)
        if leftIndex == nil && rightIndex == nil {
            return root + "\(self.elements[idx])\n"
        }
         
        return diagram(from: rightIndex, top: top + " ", root: top + "┌──", bottom: top + "│ ")
            + root + "\(self.elements[idx])\n" + diagram(from: leftIndex, top: bottom + "│ ", root: bottom + "└──", bottom: bottom + " ")
    }
}


public class MaxHeap<ElementType: Comparable>: Heap<ElementType>, ExpressibleByArrayLiteral {
    public init() {
        super.init(comparer: >)
    }
    
    public convenience init(elements: [ElementType]) {
        self.init()
        elements.forEach {
            add($0)
        }
    }
    
    public required convenience init(arrayLiteral elements: ElementType...) {
        self.init(elements: elements)
    }
    
}

extension MaxHeap {
    public var max: ElementType? {
        return peek()
    }
}



public class MinHeap<ElementType: Comparable>: Heap<ElementType>, ExpressibleByArrayLiteral {
    public init() {
        super.init(comparer: <)
    }
    
    public convenience init(elements: [ElementType]) {
        self.init()
        elements.forEach {
            add($0)
        }
    }
    
    public required convenience init(arrayLiteral elements: ElementType...) {
        self.init(elements: elements)
    }
}

extension MinHeap {
    public var min: ElementType? {
        return peek()
    }
}
