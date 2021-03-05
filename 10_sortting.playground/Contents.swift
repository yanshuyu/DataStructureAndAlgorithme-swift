import Foundation


let numbers = [10,9,3,4,8,4,7,0,10,]
print("numbers: \(numbers)")
print("standard sorted numbers: \(numbers.sorted())")

var copyNumbers = numbers
bubleSort(&copyNumbers)
print("buble sort copy numbers: \(copyNumbers)")

copyNumbers = numbers
selectionSort(&copyNumbers)
print("selection sort copy numbers: \(copyNumbers)")

copyNumbers = numbers
insertionSort(&copyNumbers)
print("insertion sort copy numbers: \(copyNumbers)")

print("merge sort numbers: \(mergeSort(numbers))")

print("radix sort numbers: \(numbers.radixSorted())")

copyNumbers = numbers
quickSort(&copyNumbers)
print("quick sort copy numbers: \(copyNumbers)")



