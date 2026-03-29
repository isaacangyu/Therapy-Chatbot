## Initial Setup
1. Pull and checkout `origin/jupyter`
2. Rebuild the dev container via the command palette to install the Colab extension OR install it manually in VS Code (ID: `Google.colab`)
3. Open both notebooks under `llm/`: `tunnel.ipynb` and `ollama.ipynb`
4. Click "Select Kernel" and choose "Colab", sign in with Google. You ~~may~~ **will** need to use the alternative sign in method that has you copy-paste a token (let the initial sign in attempt fail).

## Usage
1. Select Kernel --> Colab --> Create --> GPU --> T4
2. Make sure that both notebooks are selected to use this one kernel
3. Run every cell in `ollama.ipynb` except for the very last one
4. Run every cell in `tunnel.ipynb` except for the last two. You may need to wait a little and re-run the third cell a few times
5. Copy-paste the URL outputted by the third cell into `.env` with key `OLLAMA_ENDPOINT` (see `.env.example`)
6. Launch app. When interating with the chatbot, it may take a while to get an initial response.
