package cmd

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

func init() {
	rootCmd.AddCommand(initCmd)
}

var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize LTS configuration",
	Long:  `Interactive setup to create ~/.lts.yaml configuration file.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		reader := bufio.NewReader(os.Stdin)

		fmt.Println("Welcome to LTS configuration!")
		fmt.Println()

		// Check if config already exists
		homeDir, err := os.UserHomeDir()
		if err != nil {
			return fmt.Errorf("failed to get home directory: %w", err)
		}
		configPath := filepath.Join(homeDir, ".lts.yaml")

		if _, err := os.Stat(configPath); err == nil {
			fmt.Printf("Config file already exists at %s\n", configPath)
			fmt.Print("Overwrite? (y/N): ")
			response, _ := reader.ReadString('\n')
			response = strings.TrimSpace(strings.ToLower(response))
			if response != "y" && response != "yes" {
				fmt.Println("Configuration cancelled.")
				return nil
			}
		}

		// Provider selection
		fmt.Println("Select your LLM provider:")
		fmt.Println("1. Claude Code (Anthropic API)")
		fmt.Println("2. Ollama (Local)")
		fmt.Print("Choice (1-2): ")

		choice, _ := reader.ReadString('\n')
		choice = strings.TrimSpace(choice)

		var configData map[string]interface{}

		switch choice {
		case "1":
			configData = map[string]interface{}{
				"llm_provider": "claude-code",
			}
			fmt.Println()
			fmt.Println("Selected: Claude Code")
			fmt.Println("Remember to set your ANTHROPIC_API_KEY environment variable:")
			fmt.Println("  export ANTHROPIC_API_KEY=your_key_here")

		case "2":
			configData = map[string]interface{}{
				"llm_provider": "ollama",
			}

			fmt.Println()
			fmt.Println("Selected: Ollama")
			fmt.Println()

			// Ollama URL
			fmt.Print("Ollama URL (press Enter for default: http://localhost:11434): ")
			url, _ := reader.ReadString('\n')
			url = strings.TrimSpace(url)

			// Ollama Model
			fmt.Print("Model name (press Enter for default: llama3.2): ")
			model, _ := reader.ReadString('\n')
			model = strings.TrimSpace(model)

			ollamaConfig := make(map[string]string)
			if url != "" {
				ollamaConfig["url"] = url
			}
			if model != "" {
				ollamaConfig["model"] = model
			}

			if len(ollamaConfig) > 0 {
				configData["ollama"] = ollamaConfig
			}

		default:
			return fmt.Errorf("invalid choice: %s", choice)
		}

		// Write config file
		yamlData, err := yaml.Marshal(configData)
		if err != nil {
			return fmt.Errorf("failed to marshal config: %w", err)
		}

		if err := os.WriteFile(configPath, yamlData, 0600); err != nil {
			return fmt.Errorf("failed to write config file: %w", err)
		}

		fmt.Println()
		fmt.Printf("Configuration saved to %s\n", configPath)
		fmt.Println("You're all set! Try running: lts list all files in current directory")

		return nil
	},
}