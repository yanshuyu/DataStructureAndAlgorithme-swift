import Foundation

var myQueue = queue<String>()
myQueue.enqueue("java")
myQueue.enqueue("c++")
myQueue.enqueue("c")
print("enque java, c++, c, myQueue: \(myQueue), element count: \(myQueue.count)")
print("myQueue first element: \(myQueue.first!), last element: \(myQueue.last!)")
print("\n\n")
print("after deque element: \(myQueue.dequeue()!), \(myQueue.dequeue()!), myQueue: \(myQueue), element count: \(myQueue.count)")
print("myQueue first element: \(myQueue.first!), last element: \(myQueue.last!)")
print("after dequeue element: \(myQueue.dequeue()!), myQueue: \(myQueue), element count: \(myQueue.count)")

print("\n\n")
let testQueue: queue<Int> = [1,2,3,4]
print("testQueue: \(testQueue), count: \(testQueue.count)")
