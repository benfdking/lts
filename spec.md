

# LTS is a simple cli tool that converts english into a cli command


## Built in go 

- Simple and uses cobra
- Has autocompletion

# Usage

> lts add all my files to git and then commit it with the message "finished"
 
should return 

> git add . && git commit -m "finished"

# Setup 

initially it should look at ~/.lts.yaml
for which llm provider to use 

## Available llms

### Claude code 


