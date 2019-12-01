import Foundation




var myStack = stack<Int>()
myStack.push(1)
myStack.push(2)
myStack.push(3)
myStack.push(4)
print("after push 1,2,3,4, myStack: \(myStack)")
print("top element: \(myStack.top!)")

myStack.pop()
myStack.pop()
print("after pop 2 elements, myStack: \(myStack)")
myStack.pop()
myStack.pop()
print("after pop 2 elements again, myStack: \(myStack)")

print("\n\n")
var myStack2: stack<Float> = [1.1, 2.2, 3.3, 4.4]
print("myStack2: \(myStack2)")

