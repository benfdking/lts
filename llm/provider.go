package llm

import (
	"fmt"
)

type Provider interface {
	Translate(prompt string) (string, error)
}

func NewProvider(providerName string) (Provider, error) {
	switch providerName {
	case "claude-code":
		return &ClaudeCodeProvider{}, nil
	default:
		return nil, fmt.Errorf("unsupported LLM provider: %s", providerName)
	}
}
