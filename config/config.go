package config

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

// Config for lts. The general structure of it is the provider which matches
// the then following name of the corresponding config block.
type Config struct {
	Provider  string     `json:"provider"`
	Ollama    *Ollama    `json:"ollama,omitempty"`
	Anthropic *Anthropic `json:"anthropic,omitempty"`
	OpenAI    *OpenAI    `json:"openai,omitempty"`
}

type Ollama struct {
	URL   string `json:"url"`
	Model string `json:"model"`
}

type Anthropic struct {
	Model string `json:"model"`
}

type OpenAI struct {
	Model string `json:"model"`
}

// Load the config from the dotfile location.
func Load() (*Config, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	configPath := filepath.Join(homeDir, ".lts.json")
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file %s: %w", configPath, err)
	}

	var cfg Config
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %w", err)
	}

	return &cfg, nil
}
