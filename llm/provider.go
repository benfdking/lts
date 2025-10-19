package llm

import (
	"fmt"

	"github.com/benfdking/lts/config"
)

type Provider interface {
	Translate(prompt string) (string, error)
}

func NewProvider(cfg *config.Config) (Provider, error) {
	switch cfg.Provider {
	case "claude-code":
		return &ClaudeCodeProvider{}, nil
	case "anthropic":
		return &AnthropicProvider{}, nil
	case "openai":
		provider := &OpenAIProvider{}
		if cfg.OpenAI != nil {
			provider.Model = cfg.OpenAI.Model
		}
		return provider, nil
	case "ollama":
		provider := &OllamaProvider{}
		if cfg.Ollama != nil {
			provider.URL = cfg.Ollama.URL
			provider.Model = cfg.Ollama.Model
		}
		return provider, nil
	case "test":
		provider := &TestProvider{}
		if cfg.Test != nil {
			provider.Seconds = cfg.Test.Seconds
			provider.Text = cfg.Test.Text
		}
		return provider, nil
	default:
		return nil, fmt.Errorf("unsupported LLM provider: %s", cfg.Provider)
	}
}
