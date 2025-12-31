# Install compile tool:
#   nvm use stable
#   npm install -g @mermaid-js/mermaid-cli

mmdc -i demo.mmd -o demo.png
mmdc -i demo.mmd -o demo_gb_transparent.png -t dark -b transparent
mmdc -i demo.mmd -o demo.svg
