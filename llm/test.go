package llm

import (
	"time"
)

type TestProvider struct {
	Seconds int
	Text    string
}

func (t *TestProvider) Translate(prompt string) (string, error) {
	seconds := t.Seconds
	if seconds == 0 {
		seconds = 1
	}

	text := t.Text
	if text == "" {
		text = "test output"
	}

	time.Sleep(time.Duration(seconds) * time.Second)

	return text, nil
}
