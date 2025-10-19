#!/bin/bash

# Record the demo using asciinema with expect script
asciinema rec \
  --overwrite \
  --command "expect /demo/demo.exp" \
  --cols 140 \
  --rows 35 \
  /demo/output/demo.cast

# Convert asciinema recording to GIF using agg
/root/.cargo/bin/agg \
  --theme monokai \
  --font-size 18 \
  --speed 1.0 \
  /demo/output/demo.cast \
  /demo/output/demo.gif
