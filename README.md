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



## Media



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
