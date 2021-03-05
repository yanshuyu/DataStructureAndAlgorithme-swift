import Foundation

public func bubleSort<CollectionType> (_ collection: inout CollectionType)
    where CollectionType: MutableCollection, CollectionType.Element: Comparable {
        if collection.count < 2 {
            return
        }
        for end in collection.indices.reversed() {
            var swap = false
            var current = collection.startIndex
            while current < end {
                let next = collection.index(after: current)
                if collection[next] < collection[current] {
                    collection.swapAt(current, next)
                    swap = true
                }
                current = next
            }
            
            if !swap {
                return
            }
        }
}

public func selectionSort<CollectionType>(_ collection: inout CollectionType)
    where CollectionType: MutableCollection, CollectionType.Element: Comparable {
        if collection.count < 2 {
            return
        }
        
        for current in collection.indices {
            var lowest = current
            var other = collection.index(after: current)
            while other != collection.endIndex {
                if collection[other] < collection[lowest] {
                    lowest = other
                }
                other = collection.index(after: other)
            }
            
            if lowest != current {
                collection.swapAt(current, lowest)
            }
        }
}

public func insertionSort<CollectionType>(_ collection: inout CollectionType)
    where CollectionType: MutableCollection, CollectionType: BidirectionalCollection, CollectionType.Element: Comparable {
        if collection.count < 2 {
            return
        }
        for inserted in collection.indices {
            if inserted == collection.startIndex {
                continue
            }
            
            var current = inserted
            while current != collection.startIndex {
                let prev = collection.index(before: current)
                if collection[current] < collection[prev] {
                    collection.swapAt(current, prev)
                }
                current = prev
            }
        }
}

public func mergeSort<Element>(_ elements: [Element]) -> [Element] where Element: Comparable {
    //divide
    guard elements.count > 1 else {
        return elements
    }
    let middle = elements.count / 2
    let leftHalf = mergeSort(Array(elements[..<middle]))
    let rightHalf = mergeSort(Array(elements[middle...]))
    //conquer
    return merge(leftHalf, rightHalf)
}

fileprivate func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable {
    var result = [Element]()
    var leftIndex = 0
    var rightIndex = 0
    
    while leftIndex < left.count && rightIndex < right.count {
        if left[leftIndex] < right[rightIndex] {
            result.append(left[leftIndex])
            leftIndex += 1
        } else if left[leftIndex] > right[rightIndex] {
            result.append(right[rightIndex])
            rightIndex += 1
        } else {
            result.append(left[leftIndex])
            result.append(right[rightIndex])
            leftIndex += 1
            rightIndex += 1
        }
    }
    
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    
    return result
}


extension Array where Element == Int {
    public func radixSorted() -> Self {
        var copy = self
        let base = 10
        var stop = false
        var digits = 1
        
        while !stop {
            stop = true
            var buckets: [[Element]] = .init(repeating: [], count: base)
            copy.forEach { (i) in
                let remainder = i / digits
                let leastSignificateDigit = remainder % 10
                buckets[leastSignificateDigit].append(i)
                if leastSignificateDigit > 0 {
                    stop = false
                }
            }
            copy = buckets.flatMap { $0 }
            digits *= base
        }
        
        return copy
    }
}

public func quickSort<T: Comparable>(_ elements: inout [T]){
    quickSortImp(elements: &elements, low: 0, high: elements.count-1)
}

fileprivate func quickSortImp<T: Comparable>(elements: inout [T], low: Int, high: Int) {
    if low < high {
        let pivit = partitionQuickSort(elements: &elements, low: low, high: high)
        quickSortImp(elements: &elements, low: low, high: pivit-1)
        quickSortImp(elements: &elements, low: pivit+1, high: high)
    }
}

fileprivate func partitionQuickSort<T: Comparable>(elements: inout [T], low: Int, high: Int) -> Int {
    let povit = elements[high]
    var i = low
    for j in low..<high {
        if elements[j] <= povit {
            elements.swapAt(i, j)
            i += 1
        }
    }
    elements.swapAt(i, high)
    return i
}
