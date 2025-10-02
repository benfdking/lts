package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var shellIntegrationCmd = &cobra.Command{
	Use:   "shell-integration [bash|zsh|fish]",
	Short: "Output shell integration code to inject commands into your prompt",
	Long: `Output shell-specific wrapper functions that allow LTS to inject
generated commands directly into your shell's input buffer instead of just printing them.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		shell := args[0]

		switch shell {
		case "bash":
			fmt.Print(bashIntegration)
		case "zsh":
			fmt.Print(zshIntegration)
		case "fish":
			fmt.Print(fishIntegration)
		default:
			fmt.Fprintf(os.Stderr, "Unsupported shell: %s\n", shell)
			fmt.Fprintf(os.Stderr, "Supported shells: bash, zsh, fish\n")
			os.Exit(1)
		}

		return nil
	},
}

const bashIntegration = `# LTS wrapper for bash - adds command to readline buffer
lts() {
    local cmd
    cmd=$(command lts "$@")
    if [ $? -eq 0 ] && [ -n "$cmd" ]; then
        # Use bind to insert command into readline buffer
        bind '"\e[0n": "'"$cmd"'"'
        bind '"\e[0n"'
    fi
}
`

const zshIntegration = `# LTS wrapper for zsh - adds command to buffer
lts() {
    local cmd
    cmd=$(command lts "$@")
    if [ $? -eq 0 ] && [ -n "$cmd" ]; then
        # Use print -z to add to zsh buffer
        print -z "$cmd"
    fi
}
`

const fishIntegration = `# LTS wrapper for fish - adds command to commandline
function lts
    set -l cmd (command lts $argv)
    if test $status -eq 0; and test -n "$cmd"
        # Use commandline to set the buffer
        commandline -r "$cmd"
    end
end
`

func init() {
	rootCmd.AddCommand(shellIntegrationCmd)
}
