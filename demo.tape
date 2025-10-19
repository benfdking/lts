Output demo.gif
Set Shell zsh
Set FontSize 16
Set Width 1200
Set Height 600
Set TypingSpeed 50ms
Set Theme "Catppuccin Mocha"

# Wait for prompt to be ready
Sleep 500ms

# Source the lts.zsh script to make lts function available
Type "source scripts/lts.zsh"
Enter
Sleep 1s

# Demo: Convert natural language to git command
Type "lts list all the gifs in this folder"
Sleep 1s
Enter

# Wait for the command to appear in the buffer
Sleep 2s
Enter

# Show the generated command
Sleep 2s
