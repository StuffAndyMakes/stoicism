# Stoicism

A simple, elegant command-line utility for macOS that delivers daily wisdom from ancient Stoic philosophers. Get inspired by Marcus Aurelius, Seneca, and Epictetus right in your terminal.

## Features

- 🎲 **Random quotes by default** - Fresh wisdom every time
- 📅 **Daily mode** - Same quote all day for reflection
- 📁 **Flexible storage** - Use default location or custom JSON files
- 🔍 **Source inspection** - Troubleshoot file paths easily
- 🚀 **Fast and lightweight** - Native Swift, no dependencies
- 🎯 **Unix-style** - Follows command-line best practices

## Installation

### Build from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/stoicism.git
cd stoicism

# Build with Swift
swift build -c release

# Copy to your PATH
cp .build/release/stoicism /usr/local/bin/
```

### Quick Setup

1. Create your quotes file at the default location:
   ```bash
   cp quotes.json ~/stoic-quotes.json
   ```

2. Run it:
   ```bash
   stoicism
   ```

## Usage

### Basic Commands

```bash
# Get a random quote (default behavior)
stoicism

# Get the daily quote (same quote all day)
stoicism --daily
stoicism -d

# Check which file is being used
stoicism --source
stoicism -s

# Show help
stoicism --help

# Show version
stoicism --version
```

### Using Custom Quote Files

```bash
# Use a specific file
stoicism ./my-quotes.json

# Daily quote from custom file
stoicism -d ~/Documents/stoic-quotes.json

# Check source with custom path
stoicism -s ./quotes.json
```

### Integration Ideas

Add to your shell profile for daily wisdom:

```bash
# ~/.zshrc or ~/.bashrc
stoicism --daily
```

Create an alias for quick access:

```bash
alias wisdom='stoicism'
alias daily-wisdom='stoicism --daily'
```

Use with macOS shortcuts or cron jobs for notifications.

## Quote File Format

The application reads quotes from a JSON file with the following structure:

```json
{
  "quotes": [
    {
      "text": "You have power over your mind - not outside events.",
      "author": "Marcus Aurelius",
      "source": "Meditations"
    },
    {
      "text": "We suffer more often in imagination than in reality.",
      "author": "Seneca"
    }
  ]
}
```

### Fields

- `text` (required) - The quote text
- `author` (required) - Who said it
- `source` (optional) - Book, letter, or source material

## Configuration

### Default Location

The application looks for quotes at `~/stoic-quotes.json` by default. If this file exists, no command-line argument is needed.

### Override Default

Provide any path as an argument to override the default:

```bash
stoicism /path/to/custom-quotes.json
```

## Output Format

Quotes are displayed with elegant formatting:

```
"The happiness of your life depends upon the quality of your thoughts."
— Marcus Aurelius, Meditations
```

## Error Handling

The application provides clear error messages and follows Unix conventions:

- **Exit code 0**: Success
- **Exit code 1**: Error (file not found, invalid JSON, etc.)
- **Errors go to stderr**: Can be redirected separately from output

### Common Errors

```bash
# No default file and no argument provided
Error: No quotes file found. Default location ~/stoic-quotes.json does not exist.

# Specified file doesn't exist
Error: File not found at path: /some/path.json

# Invalid JSON format
Error: Invalid JSON format: <details>

# Empty quotes array
Error: Quote collection is empty.
```

## Examples

### Sample Output

```bash
$ stoicism
"Waste no more time arguing about what a good man should be. Be one."
— Marcus Aurelius, Meditations

$ stoicism --daily
"It is not that we have a short time to live, but that we waste a lot of it."
— Seneca, On the Shortness of Life

$ stoicism --source
Quote source: /Users/andy/stoic-quotes.json
```

### Piping and Redirection

```bash
# Save quote to file
stoicism > quote-of-the-day.txt

# Use in notifications (macOS)
osascript -e "display notification \"$(stoicism)\" with title \"Daily Stoicism\""

# Combine with other tools
stoicism | cowsay
```

## Daily Mode Explained

When using `--daily` mode, the application generates a deterministic seed based on today's date (year, month, day). This ensures:

- ✅ Same quote throughout the entire day
- ✅ Different quote each day
- ✅ Predictable rotation through your quote collection
- ✅ No need for state files or databases

Everyone using the same quotes file will see the same daily quote, making it perfect for teams or shared inspiration.

## Troubleshooting

### Check Your File Path

```bash
stoicism --source
```

This shows the exact expanded path being used, helping debug location issues.

### Verify JSON Format

Use `jq` or another JSON validator:

```bash
jq . ~/stoic-quotes.json
```

### File Permissions

Ensure the quotes file is readable:

```bash
ls -l ~/stoic-quotes.json
chmod 644 ~/stoic-quotes.json
```

## Building and Development

### Requirements

- macOS 14.0+ (Sonoma) or later
- Swift 6.0+
- Xcode 16.0+ (for development)

### Build

```bash
# Debug build
swift build

# Release build
swift build -c release

# Run directly
swift run stoicism
```

### Run Tests

```bash
swift test
```

## Included Quotes

The repository includes `quotes.json` with 15 carefully selected quotes from:

- **Marcus Aurelius** - Roman Emperor and Stoic philosopher
- **Seneca** - Roman Stoic philosopher and statesman  
- **Epictetus** - Greek Stoic philosopher

Feel free to expand, modify, or replace these with your own collection!

## Contributing

Contributions are welcome! Whether it's:

- 📝 Adding more quotes
- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements

Please feel free to submit issues and pull requests.

## Philosophy

This tool embodies Stoic principles:

- **Simplicity** - Does one thing well
- **Utility** - Practical daily wisdom
- **Accessibility** - No barriers to entry
- **Reflection** - Encourages daily contemplation

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright © 2026 Andy Frey

## Author

**Andy Frey**  
🌐 [StuffAndyMakes.com](https://StuffAndyMakes.com)

---

*"The happiness of your life depends upon the quality of your thoughts."* — Marcus Aurelius
