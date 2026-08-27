# Mental Health App

> [!Note]
> This project was developed **without** the use of AI agents.  
> While fully functional, our rate of development was too slow to be sustainable.  
> Combined with the graduation of the PM and time commitments of project members, this project is on hiatus.

## Features

- Agentic chatbot with long-term memory / RAG
- Breathing, Journaling, Login, Profile pages
- Cryptography (E2E)
  > Needs work...
- Synced and offline persistent storage
- Containerization with Docker

Platform Support: web, mobile (Android), desktop (Windows, Linux)

## Getting Started

For local development, follow the documentation as outlined in [`docs/local_setup.md`](./docs/local_setup.md) and [`docs/colab.md`](./docs/colab.md).

> Development with GitHub Codespaces was possible (see branch `codespace-compat`), but has not been updated for a while.

> Development with IDX / Firebase Studio is no longer possible since Google deprecated the product.

<img width="500" alt="Tech Stack" src="https://github.com/user-attachments/assets/44711885-0fe9-488e-a945-2062fa624be9" />

## Media

> Media collected during development. Messages with the chatbot are unrelated to the app's purpose.

<img width="250" alt="Chat" src="https://github.com/user-attachments/assets/ca86b290-23ac-4342-8661-1b8c194d7dc5" />
<img width="250" alt="Breathing" src="https://github.com/user-attachments/assets/36fbc25f-0881-4e43-ba51-676dfb9bc28b" />

<br>

<img width="500" alt="Fruit" src="https://github.com/user-attachments/assets/1f586731-9c0b-4024-966d-0bf818866764" />

<br>

<img width="500" alt="Journal" src="https://github.com/user-attachments/assets/f0891c21-a682-477b-b39b-8684c463567d" />

<br>

<img width="508" height="490" alt="Memory Graph" src="https://github.com/user-attachments/assets/a32a0baf-e049-4fe5-af20-157b209ea876" />

> The memory graph is not an app feature.

<img width="250" alt="Login 1" src="https://github.com/user-attachments/assets/9b81b6a8-063f-4e66-b7d5-61942bdd109d" />
<img width="250" alt="Login 2" src="https://github.com/user-attachments/assets/1d57c493-c82d-4f22-a8f8-f9bc8bf86b7e" />

<br>

<img width="500" alt="Adaptive Layout" src="https://github.com/user-attachments/assets/37d600f5-7263-4c10-89fa-4f2f0b29e75d" />

https://github.com/user-attachments/assets/26593acc-07d2-4ae1-b563-aade4afe2697

## Live Deployment

We had a live deployment at [`isaacangyu.github.io/Therapy-Chatbot/app`](https://isaacangyu.github.io/Therapy-Chatbot/app) (GH Pages + GCP Cloud Run & Compute Engine).  
The GCP component is currently offline as of writing this since we do incur a small GCP fee, so the deployment will not work.

## Future Features

- Chatbot model development
  - Trained on therapist conversations
  - Sentiment analysis
  - Therapist recommendations
- Track/plot app feature usage
- Internationalization and localization (i18n / I10n)
- OAuth sign in
- Sending emails
