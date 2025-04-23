# CopyClip - Open Source Clipboard Manager for macOS

![macOS](https://img.shields.io/badge/macOS-10.12+-000000?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.0+-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

CopyClip is a lightweight, efficient clipboard manager for macOS that keeps track of your clipboard history. It runs in the menu bar, providing quick access to your recently copied items.

## Features

- 📋 **Clipboard History**: Automatically saves your copied text
- ⚡ **Lightweight**: Minimal memory footprint and efficient performance
- 🎯 **Easy Access**: Quick access from the menu bar
- 🔒 **Secure**: No cloud storage or data sharing
- 🎨 **Native Experience**: Built with Swift and native macOS APIs
- 🔄 **Real-time Updates**: Instantly captures new clipboard content

## Installation

### Requirements
- macOS 10.12 or later
- Xcode 12.0 or later (for development)

### Building from Source
1. Clone the repository:
```bash
git clone https://github.com/yourusername/copyclip_opensource.git
```

2. Open the project in Xcode:
```bash
cd copyclip_opensource
open copyclip_opensource.xcodeproj
```

3. Build and run the project in Xcode

## Usage

Once installed, CopyClip will appear in your menu bar. Click the icon to:
- View your clipboard history
- Select any previous item to copy it back to your clipboard
- Access recent items quickly

## Development

The project is built with modern Swift practices and follows clean architecture principles:

- **Modular Design**: Separated concerns with dedicated managers for clipboard and menu operations
- **Memory Efficient**: Optimized for minimal resource usage
- **Error Handling**: Robust error handling and user feedback
- **Accessibility**: Built with accessibility in mind

### Project Structure
- `AppDelegate.swift`: Main application entry point
- `ClipboardManager.swift`: Handles clipboard operations
- `MenuManager.swift`: Manages the menu bar interface

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with ❤️ using Swift
- Inspired by the need for a simple, efficient clipboard manager 