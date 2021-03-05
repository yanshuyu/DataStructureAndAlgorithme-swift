import Foundation
//
// MARK: -回溯算法
//
//回溯算法(Backtracking Algorithm)，实际上一个类似枚举的搜索尝试过程，主要是在搜索尝试过程中寻找问题的解，当发现已不满足求解条件时，就“回溯”返回，尝试别的路径。
//回溯算法的核心包含3个元素：
//1.选择 (Options)：搜索的每一步都包含有限个选择；
//2.限制 (Restraints)：根据题目定出限制条件，描述出合法解的一般特征，用于过滤不合法解，在搜索过程中起到剪枝的效果；
//3.结束 (Termination)：当到达特定结束条件时，可认为这个一步步构建的解是符合合题目要求的解。
//
// 示例-题目描述：给出 n 代表生成括号的对数，请你写出一个函数，使其能够生成所有可能的并且有效的括号组合。例如，给出 n = 3，生成结果为：
//"((()))", "(()())", "(())()", "()(())", "()()()"

public func generateMatchBrackets(pair count: Int) -> [String] {
    guard count > 0 else {
        return []
    }
    var matches = [String]()
    __generateMatchBracketsImp(matchContainer: &matches, partialAnswer: "", leftOptions: count, rightConstrains: 0)
    return matches
}

fileprivate func __generateMatchBracketsImp(matchContainer: inout [String], partialAnswer: String, leftOptions: Int, rightConstrains: Int) {
    if leftOptions == 0 && rightConstrains == 0 {
        matchContainer.append(partialAnswer)
        return
    }
    
    if leftOptions > 0 {
        __generateMatchBracketsImp(matchContainer: &matchContainer, partialAnswer: partialAnswer+"(", leftOptions: leftOptions-1, rightConstrains: rightConstrains+1)
    }
    if rightConstrains > 0 {
        __generateMatchBracketsImp(matchContainer: &matchContainer, partialAnswer: partialAnswer+")", leftOptions: leftOptions, rightConstrains: rightConstrains-1)
    }
}

print("-------------回溯算法示例--------------")
print("test generateMatchBrackets() where n = 3: \(generateMatchBrackets(pair: 3))")


//
// MARK: - 分治算法
//
public func generateFullpermutation(_ numbers: [Int]) -> [[Int]] {
    guard numbers.count > 0 else {
        return [[]]
    }
    
    if numbers.count == 1 {
        return [numbers]
    }
    
    if numbers.count == 2 {
        return [numbers, numbers.reversed()]
    }
    
    var fullPermutation = [[Int]]()
    let partialPermutation = generateFullpermutation(Array(numbers.dropFirst()))
    partialPermutation.forEach { (sequence) in
        for idx in 0...sequence.count {
            var copy = sequence
            copy.insert(numbers.first!, at: idx)
            fullPermutation.append(copy)
        }
    }
    
    return fullPermutation
}

print("test generateFullpermutation() where numbers = [1,2,3]:\n\(generateFullpermutation([1,2,3]))")
