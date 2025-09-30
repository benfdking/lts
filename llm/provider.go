package llm

import (
	"fmt"

	"github.com/benfdking/lts/config"
)

type Provider interface {
	Translate(prompt string) (string, error)
}

func NewProvider(cfg *config.Config) (Provider, error) {
	switch cfg.LLMProvider {
	case "claude-code":
		return &ClaudeCodeProvider{}, nil
	case "ollama":
		provider := &OllamaProvider{}
		if cfg.OllamaConfig != nil {
			provider.URL = cfg.OllamaConfig.URL
			provider.Model = cfg.OllamaConfig.Model
		}
		return provider, nil
	default:
		return nil, fmt.Errorf("unsupported LLM provider: %s", cfg.LLMProvider)
	}
}
