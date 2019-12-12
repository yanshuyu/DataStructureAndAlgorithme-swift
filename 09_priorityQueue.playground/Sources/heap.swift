import Foundation

public struct Heap<ElementType:Comparable> {
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
    
    public init(elements: [ElementType], comparer: @escaping (ElementType, ElementType)->Bool) {
        self.init(comparer: comparer)
        elements.forEach {
            add($0)
        }
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
    public mutating func add(_ element: ElementType) {
        self.elements.append(element)
        shitUp(from: self.count-1)
    }
    
    //
    // MARK: - remove highest priority element from heap
    //
    public mutating func pop() -> ElementType? {
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
    public mutating func remove(at idx: Index) -> ElementType? {
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
    
    private mutating func shitUp(from idx: Index) {
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
    
    private mutating func shitDown(from idx: Index) {
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
