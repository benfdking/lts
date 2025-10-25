# LTS - Language To Shell

![Demo](demo.gif)

A simple CLI tool that converts natural language into shell commands using AI like command k in Cursor. 

## Usage

When interactive mode is enabled, `lts` will:

1. Generate the command using AI
2. Print the generated command into the next shell line
3. Run the command by hitting enter

Simply describe what you want to do in natural language and the command appears in your next shell:

```bash
$ lts add all my files to git and then commit it with the message "finished"
$ git add . && git commit -m "finished"
```

## Installation

### Homebrew (macOS/Linux)

```bash
brew tap benfdking/lts https://github.com/benfdking/lts
brew install benfdking/lts/lts
echo 'source "$(brew --prefix)/share/lts/zsh/lts.zsh"' >> ~/.zshrc
source ~/.zshrc
lts init
```

Interactive command execution is enabled by default with Homebrew - just run `lts` and start using it!

## Configuration

Run `lts init` for interactive setup, or create a configuration file at `~/.lts.json` manually:

### Claude Code 

Use your Claude Code setup under the hood.

```json
{
  "llm_provider": "claude-code"
}
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
