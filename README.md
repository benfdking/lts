# LTS - Language To Shell

A simple CLI tool that converts natural language into shell commands using AI.

## Features

- Convert English descriptions into executable shell commands
- Support for multiple LLM providers (Claude, OpenAI, Ollama)
- Built with Go using Cobra for a robust CLI experience
- Shell autocompletion support (bash, zsh, fish, powershell)
- Cross-platform releases (Linux, macOS, Windows)

## Installation

### Quick Install (All Platforms)

```bash
curl -fsSL https://raw.githubusercontent.com/benfdking/lts/main/install.sh | sh
```

This script automatically detects your OS and architecture, then downloads and installs the appropriate binary.

### Homebrew (macOS/Linux)

```bash
brew tap benfdking/lts https://github.com/benfdking/lts
brew install lts
```

Interactive command execution is enabled by default with Homebrew - just run `lts` and start using it!

### Download pre-built binaries

Download the latest release from the [releases page](https://github.com/benfdking/lts/releases).

### Build from source

```bash
git clone https://github.com/benfdking/lts.git
cd lts
go build -o lts
```

## Configuration

Create a configuration file at `~/.lts.json`:

### Claude Code (Recommended)

Uses the Claude Code CLI with automatic authentication from your Claude login.

```json
{
  "llm_provider": "claude-code"
}
```

First, install Claude Code and login:
```bash
npm install -g @anthropic-ai/claude-code
claude login
```

### Anthropic API

Uses the Anthropic API directly with an API key.

```json
{
  "llm_provider": "anthropic"
}
```

Set your API key:
```bash
export ANTHROPIC_API_KEY=your_key_here
```

### OpenAI

```json
{
  "llm_provider": "openai"
}
```

Set your API key:
```bash
export OPENAI_API_KEY=your_key_here
```

### Ollama (Local LLM)

```json
{
  "llm_provider": "ollama",
  "ollama": {
    "url": "http://localhost:11434",
    "model": "llama3.2"
  }
}
```

## Interactive Command Execution

### Homebrew Installation (Automatic)

If you installed via Homebrew, interactive mode is **enabled by default** - no additional setup needed! Just run `lts` and it will prompt you to execute commands.

### Manual Installation (Install Script)

If you used the install script, you can enable interactive mode by sourcing the wrapper in your shell config:

```bash
# For Bash (~/.bashrc) or Zsh (~/.zshrc)
source /usr/local/share/lts/lts-wrapper.sh
```

Then reload your shell or run: `source ~/.bashrc` (or `~/.zshrc`)

### How It Works

When interactive mode is enabled, `lts` will:
1. Generate the command using AI
2. Show you the command
3. Prompt "Execute? (y/N)" for confirmation
4. Run the command if you confirm

Without interactive mode, `lts` only prints the command to stdout.

## Usage

### Interactive Mode (with wrapper enabled)

Simply describe what you want to do in natural language:

```bash
$ lts add all my files to git and then commit it with the message "finished"
Generated command:
  git add . && git commit -m "finished"

Execute? (y/N): y

[git output]
```

### Raw Output Mode (without wrapper or with --raw flag)

Use the `--raw` flag for scripting or when the wrapper is not enabled:

```bash
$ lts add all my files to git and then commit it with the message "finished"
git add . && git commit -m "finished"
```

```bash
$ lts --raw list all pdf files in the current directory
ls *.pdf
```

```bash
$ lts --raw find all typescript files modified in the last 7 days
find . -name "*.ts" -mtime -7
```

### Using in Scripts

The `--raw` flag is useful for piping or scripting:

```bash
# Execute directly without prompts
$ eval "$(lts --raw list all pdf files)"

# Save to a variable
$ CMD=$(lts --raw find large files)
$ echo "Generated: $CMD"
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
