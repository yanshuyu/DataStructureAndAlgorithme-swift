import Foundation


var maxPriorityQueue = PriorityQueue<Int>(values: [4,1,8,0,6,9,7], sort: >)
print(maxPriorityQueue)

while !maxPriorityQueue.isEmpty {
    print(maxPriorityQueue.dequeue()!)
}

