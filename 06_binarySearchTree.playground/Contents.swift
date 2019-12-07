import Foundation



//var testTree: binarysearchtree<Int> = [5,1,3,4,2,6,9,7,8,10]
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//print("in order traverse:")
//testTree.traverse(operation: { (value, stop) in
//    print(value)
//}, policy: .Inorder)
//
//let node_11 = testTree.insert(11)
//print("\n\nafter insert: \(node_11)(parent:\(node_11.parent!))")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 2)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 3)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 9)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("\n\nafter remove: \(testTree.remove(value: 5)!.value)")
//print("\(testTree), cout: \(testTree.count), min: \(testTree.min!), max: \(testTree.max!)")
//
//print("in order traverse:")
//testTree.traverse(operation: { (value, stop) in
//    print(value)
//}, policy: .Inorder)
//
//let unbanlanceTree: binarysearchtree<Int> = [1,2,3,4,5,6,7,8,9,10]
//print("unbalance tree:\n \(unbanlanceTree)")
//print("unbalance tree contain 6 ? : \(unbanlanceTree.contain(6))")
//print("unbalance tree contain 11 ? : \(unbanlanceTree.contain(11))")
//
//let pow2 = unbanlanceTree.map {$0 * $0 }

print("\n\n---------- AVL Tree -----------")

func generateRandomNumbers(count: Int, min: Int, max: Int) -> [Int] {
    var numbers = [Int]()

    for _ in 0..<count {
        numbers.append(Int.random(in: min...max))
    }

    return numbers
}

var balanceTree = binarysearchtree<Int>()
var numbers =  generateRandomNumbers(count: 50, min: 0, max: 1000)
numbers = [Int](Set(numbers))

print("numbers: \(numbers)")
numbers.forEach { (value) in
    balanceTree.insert(value)
    print("after insert \(value), balance tree: \n\(balanceTree)")
}

print("lefr rotattion count: \(balanceTree.lrCount)")
print("right rotattion count: \(balanceTree.rrCount)")
print("left-right rotattion count: \(balanceTree.lrrCount)")
print("right-lefr rotattion count: \(balanceTree.rlrCount)")
balanceTree.traverse(operation: { (value, stop) in
    print(value)
}, policy: .Inorder)

//var bst = binarysearchtree<Int>()
//[1,6,3,4,9,8,33,5,7,10,22,0].forEach { (value) in
//    bst.insert(value)
//    print("after insert \(value), isBST: \(bst.isBST)")
//    if !bst.isBST {
//        print(bst)
//    }
//}



