import Foundation

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1))
                }
            }
            return $0.capitalizingFirstLetter() + String($1)
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func hasNumber() -> Bool {
        return rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    func replacingFirstOccurence(of string: String, with newString: String) -> String {
        guard let range = range(of: string) else { return self }
        
        var tempStr = self
        tempStr.replaceSubrange(range, with: newString)
        return tempStr
    }
}

// MARK: - String masking
extension String {

    private enum Token {
        case digit, any
        case symbol(Character)
    }
    
    private enum MaskErrors: Error {
        case IndexOutOfBounds
    }
    
    /// Takes a pattern and masks it over the given string
    ///
    /// Use # to represent a digit and * to represent other characters.
    /// Any other characters will be inserted automatically into the resulting string
    ///
    ///     let string = "02182000"
    ///     let maskedStr = string.mask(withPattern: "## / ## / ####")
    ///     print(maskedStr)
    ///     // Prints "02 / 18 / 2000"
    ///
    /// - Parameters:
    ///   - pattern: The pattern to mask over the given string
    ///   - exhaustive: Whether the pattern should continue being inserted
    ///     once the given string has finished inserting all of its characters
    /// - Returns: The final masked string
    func mask(withPattern pattern: Self, exhaustive: Bool = true) -> Self {
        var maskedStr = ""
        var str = Substring(self)
        let tokens = generateTokens(pattern: pattern)
        
        tokens.forEach { token in
            if !exhaustive && str.isEmpty { return }
            
            switch token {
            case .digit, .any:
                if !str.isEmpty {
                    maskedStr += String(str.removeFirst())
                }
            case .symbol(let char):
                maskedStr += String(char)
            }
        }
        return maskedStr + str
    }
    
    private func generateTokens(pattern: Self) -> [Token] {
        return pattern.map { char in
            switch char {
            case "#":
                return .digit
            case "*":
                return .any
            default:
                return .symbol(char)
            }
        }
    }
}

// MARK: - Boyer-Moore Algorithm
extension String {
    
    /// Preprocessor for Boyer-Moore algorithm
    private var skipTable: [Character: Int] {
        var skipTable: [Character: Int] = [:]
        enumerated().forEach { idx, char in
            skipTable[char] = count - idx - 1
        }
        return skipTable
    }
    
    /// Performs backwards string matching on the source string using the given pattern
    private func match(from currentIndex: Index, with pattern: String) -> Index? {
        guard currentIndex >= startIndex && currentIndex < endIndex else { return nil }
        guard self[currentIndex] == pattern.last else { return nil }
        
        if pattern.count == 1 {
            return currentIndex
        }
        
        return match(from: index(before: currentIndex), with: "\(pattern.dropLast())")
    }
    
    /// Traverses the source string to find the matching pattern using the Boyer-Moore algorithm
    ///
    /// - Returns: The first index of the source string where the pattern occurs or returns nil
    ///     if the pattern is not found in the source string
    ///
    /// - Complexity: O(*mn*), where *m* is the the length of the `pattern` and
    ///     *n* is the length of the source string
    func index(of pattern: String) -> Index? {
        let patternCount = pattern.count
        guard let lastChar = pattern.last, patternCount <= count else { return nil }
        
        let skipTable = pattern.skipTable
        
        var idx = index(startIndex, offsetBy: patternCount - 1)
        
        while idx < endIndex {
            let char = self[idx]
            
            if char == lastChar {
                // If current character from source string matches last character of pattern
                // then check if it's a match
                if let matchingIdx = match(from: idx, with: pattern) { return matchingIdx }
                idx = index(after: idx)
            }
            else {
                // Otherwise consult the skipTable to see how many indexes we can skip
                idx = index(idx, offsetBy: skipTable[char] ?? patternCount, limitedBy: endIndex) ?? endIndex
            }
        }
        
        return nil
    }
}

// MARK: - Optional String
extension Optional where Wrapped == String {
    
    func starts(with string: String) -> Bool {
        guard let unwrappedStr = self else { return false }
        return unwrappedStr.starts(with: string)
    }
    
}

// MARK: Array of Strings
extension Array where Element == String {
    
    /// Returns the element from `draftFoodPreferences` whose id's last component
    /// starts with the given `string`
    ///
    /// - Returns: The element with matching string, or nil if element was not found
    func findByLastComponent(startsWith string: String) -> String? {
        first(where: { optionId in
            let idArray = optionId
                .split(separator: ".", maxSplits: 3, omittingEmptySubsequences: true)
                .map { String($0) }
            return idArray.last.starts(with: string)
        })
    }
    
    /// Finds all dining options for a given `sectionId` and returns them in an array.
    ///
    /// - Returns: An array of dining options with the matching `sectionId` or an
    ///            empty array if no options were foubd.
    func findAllBySection(sectionId: String) -> [String] {
        self.reduce(into: [String]()) { acc, value in
            let components = value.split(separator: ".")
            
            guard let valueOption = components.last?.description else {
                return
            }
            
            if sectionId == components[0] || sectionId == components[1] {
                acc.append(valueOption)
            }
        }
    }
    
    func firstIndex(startsWith string: String) -> Index? {
        self.firstIndex(where: { $0.starts(with: string) })
    }
}

extension String {
    var isNumeric: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
}
