package llm

import (
	"fmt"
	"os/exec"
	"strings"
)

type ClaudeCodeProvider struct{}

func (c *ClaudeCodeProvider) Translate(prompt string) (string, error) {
	// Check if claude CLI is available
	if _, err := exec.LookPath("claude"); err != nil {
		return "", fmt.Errorf("claude CLI not found. Please install it with: npm install -g @anthropic-ai/claude-code")
	}

	systemPrompt := "You are a CLI command translator. Convert natural language requests into shell commands. Return ONLY the command, nothing else. No explanations, no markdown, just the raw command."
	fullPrompt := fmt.Sprintf("%s\n\nRequest: %s", systemPrompt, prompt)

	// Use claude CLI which handles authentication automatically
	cmd := exec.Command("claude", "--prompt", fullPrompt)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("failed to run claude CLI: %w\nOutput: %s", err, string(output))
	}

	// Clean up the output
	result := strings.TrimSpace(string(output))
	return result, nil
}
