# TypeScript to Swift Bridge

This tool processes TypeScript definition (`.d.ts`) files and generates structured information about declared types for generating Swift bindings.

## Features

- Process TypeScript declaration files (`.d.ts`)
- Extract detailed type information including interfaces, classes, enums, and function signatures
- Structured output of function/method parameters and return types
- JSON output with detailed type information

## Usage

```bash
# Basic usage
node bin/ts2swift.js path/to/file.d.ts

# With output file
node bin/ts2swift.js path/to/file.d.ts -o output.json
```

## Development

### Project Structure

```
├── bin/                  # Command-line scripts
├── src/                  # Source code
│   ├── cli.js            # Command-line interface
│   ├── types/            # TypeScript type processing
│   │   ├── collector.js  # Type collection utilities
│   │   ├── processor.js  # TypeScript program processing
│   │   ├── serializer.js # Type serialization utilities
│   │   └── utils.js      # Type utility functions
│   └── utils/            # General utilities
│       └── io.js         # Input/output utilities
└── test/                 # Test suite
    ├── fixtures/         # Test fixtures
    ├── integration/      # Integration tests
    ├── unit/             # Unit tests
    └── helpers.js        # Test helper functions
```

### Testing

The project uses [Vitest](https://vitest.dev/) v0.34.6 for testing (compatible with Node.js v16):

```bash
# Run all tests
npm test

# Run tests in watch mode during development
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

### Testing Coverage

The test suite includes:

- **Unit Tests:** Test individual functions and components
  - Type utilities
  - Function type processing
  - Complex type handling
  - IO utilities

- **Integration Tests:** Test the complete flow
  - End-to-end processing of TypeScript definition files
  - TypeScript processor integration

## Output Format

The tool outputs a JSON structure with the following main sections:

- `declarations`: Top-level exported declarations
- `referencedNominalTypes`: All referenced nominal types (interfaces, classes, enums, etc.)

Function types are represented with detailed information:

```json
{
  "functionType": {
    "parameters": [
      {
        "name": "paramName",
        "type": "string",
        "optional": false
      }
    ],
    "returnType": "boolean"
  }
}
``` 
