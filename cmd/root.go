package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/benfdking/lts/config"
	"github.com/benfdking/lts/llm"
	"github.com/spf13/cobra"
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

		// Join all args into a single prompt
		prompt := strings.Join(args, " ")

		// Translate to CLI command
		command, err := provider.Translate(prompt)
		if err != nil {
			return fmt.Errorf("failed to translate command: %w", err)
		}

		// Output the command
		fmt.Println(command)

		return nil
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
