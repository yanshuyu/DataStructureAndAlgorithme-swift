import Foundation


func buildTestTree() -> binarytree<Int> {
    let node_1 = binarytree<Int>.Node(value: 1)
    let node_2 = binarytree<Int>.Node(value: 2)
    let node_3 = binarytree<Int>.Node(value: 3)
    let node_4 = binarytree<Int>.Node(value: 4)
    let node_5 = binarytree<Int>.Node(value: 5)
    let node_6 = binarytree<Int>.Node(value: 6)
    let node_7 = binarytree<Int>.Node(value: 7)
    let node_8 = binarytree<Int>.Node(value: 8)
    
    node_6.addLeft(node_3)
    node_6.addRight(node_7)
    node_2.addLeft(node_5)
    node_2.addRight(node_6)
    node_4.addRight(node_8)
    node_1.addLeft(node_2)
    node_1.addRight(node_4)
    
    return binarytree<Int>(root: node_1)
}

let testTree = buildTestTree()
print("\(testTree)")

print("pre order traverse: ")
testTree.traversePreorder { (value, stop) in
    print(value)
    if value >= 7 {
        stop = true
    }
}


print("in order traverse: ")
testTree.traverseInorder { (value, stop) in
    print(value)
}


print("post order traverse: ")
testTree.traversePostorder { (value, stop) in
    print(value)
}
