//
//  main.swift
//  stoicism
//
//  Created by Andy Frey on 4/10/26.
//

import Foundation

// MARK: - Models

struct Quote: Codable {
    let text: String
    let author: String
    let source: String?
    
    func formatted() -> String {
        var result = "\"\(text)\""
        result += "\n— \(author)"
        if let source = source {
            result += ", \(source)"
        }
        return result
    }
}

struct QuoteCollection: Codable {
    let quotes: [Quote]
}

// MARK: - Configuration

let defaultQuotesPath = "~/stoic-quotes.json"

// MARK: - Error Handling

enum StoicismError: Error, CustomStringConvertible {
    case noQuotesFileFound
    case fileNotFound(String)
    case invalidJSON(String)
    case emptyQuoteCollection
    case readError(String)
    
    var description: String {
        switch self {
        case .noQuotesFileFound:
            return "Error: No quotes file found. Default location ~/stoic-quotes.json does not exist."
        case .fileNotFound(let path):
            return "Error: File not found at path: \(path)"
        case .invalidJSON(let details):
            return "Error: Invalid JSON format: \(details)"
        case .emptyQuoteCollection:
            return "Error: Quote collection is empty."
        case .readError(let details):
            return "Error: Failed to read file: \(details)"
        }
    }
}

// MARK: - Quote Selection

func selectDailyQuote(from quotes: [Quote]) -> Quote {
    let calendar = Calendar.current
    let today = Date()
    let components = calendar.dateComponents([.year, .month, .day], from: today)
    
    // Create a deterministic seed from today's date
    let seed = (components.year! * 10000) + (components.month! * 100) + components.day!
    
    // Use the seed to select a quote (same quote all day)
    let index = seed % quotes.count
    return quotes[index]
}

func selectRandomQuote(from quotes: [Quote]) -> Quote {
    return quotes.randomElement()!
}

// MARK: - File Reading

func loadQuotes(from path: String) throws -> [Quote] {
    let fileURL: URL
    
    // Handle both absolute and relative paths
    if path.hasPrefix("/") || path.hasPrefix("~") {
        let expandedPath = NSString(string: path).expandingTildeInPath
        fileURL = URL(fileURLWithPath: expandedPath)
    } else {
        fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(path)
    }
    
    // Check if file exists
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
        throw StoicismError.fileNotFound(fileURL.path)
    }
    
    // Read file data
    let data: Data
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        throw StoicismError.readError(error.localizedDescription)
    }
    
    // Decode JSON
    let decoder = JSONDecoder()
    let collection: QuoteCollection
    do {
        collection = try decoder.decode(QuoteCollection.self, from: data)
    } catch {
        throw StoicismError.invalidJSON(error.localizedDescription)
    }
    
    guard !collection.quotes.isEmpty else {
        throw StoicismError.emptyQuoteCollection
    }
    
    return collection.quotes
}

// MARK: - Command-Line Interface

func printUsage() {
    let usage = """
    Usage: stoicism [OPTIONS] [quotes-file]
    
    Output a random Stoic quote from a JSON file.
    
    Arguments:
      [quotes-file]     Path to JSON file containing quotes
                        (default: ~/stoic-quotes.json)
    
    Options:
      -d, --daily       Select a daily quote (same quote all day)
      -s, --source      Show the path to the quotes file being used
      -h, --help        Show this help message
      -v, --version     Show version information
    
    The quotes JSON file should have the following format:
    {
      "quotes": [
        {
          "text": "Quote text here",
          "author": "Author name",
          "source": "Optional source"
        }
      ]
    }
    
    Examples:
      stoicism
      stoicism --daily
      stoicism --source
      stoicism quotes.json
      stoicism -d ~/Documents/stoic-quotes.json
      stoicism -s
    
    Author:
      Written by Andy Frey <https://StuffAndyMakes.com>
    """
    print(usage)
}

func printVersion() {
    print("stoicism version 1.0.0")
}

// MARK: - Main

func main() {
    var arguments = CommandLine.arguments.dropFirst() // Remove program name
    var useDaily = false
    var showSource = false
    var quotesPath: String?
    
    // Parse arguments
    while let arg = arguments.first {
        arguments = arguments.dropFirst()
        
        switch arg {
        case "-h", "--help":
            printUsage()
            exit(0)
        case "-v", "--version":
            printVersion()
            exit(0)
        case "-d", "--daily":
            useDaily = true
        case "-s", "--source":
            showSource = true
        default:
            if arg.hasPrefix("-") {
                fputs("Error: Unknown option: \(arg)\n", stderr)
                fputs("Use --help for usage information.\n", stderr)
                exit(1)
            } else {
                quotesPath = arg
            }
        }
    }
    
    // Determine which file to use: command-line argument or default
    let pathToUse: String
    if let providedPath = quotesPath {
        // User provided a path, use it
        pathToUse = providedPath
    } else {
        // Check if default file exists
        let expandedDefaultPath = NSString(string: defaultQuotesPath).expandingTildeInPath
        if FileManager.default.fileExists(atPath: expandedDefaultPath) {
            pathToUse = defaultQuotesPath
        } else {
            // Default doesn't exist and no path provided
            fputs("\(StoicismError.noQuotesFileFound)\n", stderr)
            fputs("Either create ~/stoic-quotes.json or provide a path as an argument.\n", stderr)
            fputs("Use --help for usage information.\n", stderr)
            exit(1)
        }
    }
    
    // If --source flag is set, show the source path and exit
    if showSource {
        let expandedPath = NSString(string: pathToUse).expandingTildeInPath
        print("Quote source: \(expandedPath)")
        exit(0)
    }
    
    // Load and display quote
    do {
        let quotes = try loadQuotes(from: pathToUse)
        // Default to random, use daily only if explicitly requested
        let quote = useDaily ? selectDailyQuote(from: quotes) : selectRandomQuote(from: quotes)
        print(quote.formatted())
        exit(0)
    } catch let error as StoicismError {
        fputs("\(error)\n", stderr)
        exit(1)
    } catch {
        fputs("Error: Unexpected error: \(error)\n", stderr)
        exit(1)
    }
}

// Run the program
main()

