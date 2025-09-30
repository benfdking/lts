# LTS - Language To Shell

A simple CLI tool that converts natural language into shell commands using AI.

## Features

- Convert English descriptions into executable shell commands
- Support for multiple LLM providers (Claude, Ollama)
- Built with Go using Cobra for a robust CLI experience
- Shell autocompletion support (bash, zsh, fish, powershell)
- Cross-platform releases (Linux, macOS, Windows)

## Installation

### Download pre-built binaries

Download the latest release from the [releases page](https://github.com/benfdking/lts/releases).

### Build from source

```bash
git clone https://github.com/benfdking/lts.git
cd lts
go build -o lts
```

## Configuration

Create a configuration file at `~/.lts.yaml`:

### Claude (Anthropic API)

```yaml
llm_provider: claude-code
```

Set your API key:
```bash
export ANTHROPIC_API_KEY=your_key_here
```

## Usage

Simply describe what you want to do in natural language:

```bash
$ lts add all my files to git and then commit it with the message "finished"
git add . && git commit -m "finished"
```

```bash
$ lts list all pdf files in the current directory
ls *.pdf
```

```bash
$ lts find all typescript files modified in the last 7 days
find . -name "*.ts" -mtime -7
```

## Shell Completion

Generate completion scripts for your shell:

```bash
# Bash
lts completion bash > /etc/bash_completion.d/lts

# Zsh
lts completion zsh > "${fpath[1]}/_lts"

# Fish
lts completion fish > ~/.config/fish/completions/lts.fish

# PowerShell
lts completion powershell > lts.ps1
```

## Development

### Running tests
```bash
go test ./...
```

### Building
```bash
go build -o lts
```

## CI/CD

The project uses GitHub Actions for:
- **CI**: Format checking, vetting, building, and testing on every push/PR
- **Releases**: Automated multi-platform releases using GoReleaser on version tags

## License

MIT