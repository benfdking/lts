package cmd

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/benfdking/lts/config"
	"github.com/benfdking/lts/llm"
	"github.com/spf13/cobra"
)

var (
	rawOutput bool
)

var rootCmd = &cobra.Command{
	Use:   "lts [natural language command]",
	Short: "Convert natural language to CLI commands",
	Long:  `LTS is a CLI tool that converts English into shell commands using AI.`,
	Args:  cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		// Load config
		cfg, err := config.Load()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n\n", err)
			fmt.Fprintf(os.Stderr, "It looks like you haven't set up LTS yet.\n")
			fmt.Fprintf(os.Stderr, "Run 'lts init' to create your configuration file.\n")
			os.Exit(1)
		}

		// Create LLM provider
		provider, err := llm.NewProvider(cfg)
		if err != nil {
			return fmt.Errorf("failed to create LLM provider: %w", err)
		}

		// Detect shell type
		shellType := detectShell()

		// Join all args into a single prompt and inject shell type
		userPrompt := strings.Join(args, " ")
		prompt := fmt.Sprintf("Generate a command for %s shell: %s", shellType, userPrompt)

		// Translate to CLI command
		command, err := provider.Translate(prompt)
		if err != nil {
			return fmt.Errorf("failed to translate command: %w", err)
		}

		// Output the command
		fmt.Print(command)

		return nil
	},
}

func detectShell() string {
	// Check SHELL environment variable first
	shell := os.Getenv("SHELL")
	if shell != "" {
		// Extract just the shell name (e.g., /bin/bash -> bash)
		return filepath.Base(shell)
	}

	// Fallback to checking common shell-specific variables
	if os.Getenv("ZSH_VERSION") != "" {
		return "zsh"
	}
	if os.Getenv("BASH_VERSION") != "" {
		return "bash"
	}
	if os.Getenv("FISH_VERSION") != "" {
		return "fish"
	}

	// Default fallback
	return "bash"
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.Flags().BoolVar(&rawOutput, "raw", false, "Output raw command without prompts (for scripting)")
}
