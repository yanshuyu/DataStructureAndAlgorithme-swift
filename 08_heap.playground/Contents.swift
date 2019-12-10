import Foundation


let miHeap: MinHeap<Int> = [1,2,3,4,5,6,7,8]
print("minHeap:\n \(miHeap), min: \(miHeap.min)")


print("------- insert element -------")
var maxHeap: MaxHeap<Int> = [5,10,6,20]
print(maxHeap)
print(maxHeap.peek()!)

maxHeap.add(7)
print("after insert: 7, heap:\n\(maxHeap)")
print(maxHeap.peek()!)

maxHeap.add(8)
print("after insert: 8, heap:\n\(maxHeap)")
print(maxHeap.peek()!)

maxHeap.add(44)
print("after insert: 44, heap:\n\(maxHeap)")
print(maxHeap.peek()!)

print("index of element 6: \(maxHeap.index(for: 6) ?? -1)")
print("index of element 100: \(maxHeap.index(for: 100) ?? -1)")
print("index of element 44: \(maxHeap.index(for: 44) ?? -1)")

print("-------- remove element ------")
print("after remove: \(maxHeap.remove(at: maxHeap.index(for: 7)!)), heap: \n \(maxHeap)")
print("after remove: \(maxHeap.remove(at: maxHeap.index(for: 10)!)), heap: \n \(maxHeap)")
print("after pop: \(maxHeap.pop()), heap: \n \(maxHeap)")

print("index of element 6: \(maxHeap.index(for: 6) ?? -1)")
print("index of element 10: \(maxHeap.index(for: 10) ?? -1)")
