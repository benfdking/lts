# Development

## Running tests
```bash
go test ./...
```

## Building
```bash
go build -o lts
```

## CI/CD

The project uses GitHub Actions for:
- **CI**: Format checking, vetting, building, and testing on every push/PR
- **Releases**: Automated multi-platform releases using GoReleaser on version tags
