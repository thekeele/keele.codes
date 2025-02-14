mark keele
========

welcome to the source code for my website [keele.codes](https://keele.codes/)

my website is built using [elixir-lang](https://elixir-lang.org/) and currently runs sentiment analysis on tweets from twitter

the following technologies are used:
- [PhoenixFramework](https://www.phoenixframework.org/) as the web framework to build this app
- [Phoenix.LiveView](https://github.com/phoenixframework/phoenix_live_view) to display tweets in real-time and recompute topic sentiment
- [Elixir.GenServer](https://hexdocs.pm/elixir/1.18.2/GenServer.html) for a tweet and sentiment server
- [Phoenix.PubSub](https://github.com/phoenixframework/phoenix_pubsub) to communicate between the tweet server, sentiment server, and UI
- [X API](https://docs.x.com/x-api/posts/search/introduction) for Tweet data
- [HuggingFace AI models](https://huggingface.co/models) for BERTweet model
- [Elixir.Nx.Bumblebee](https://github.com/elixir-nx/bumblebee) to load model and classify text
- [TailwindCSS](https://tailwindcss.com/) for UI
- [DigitalOcean](https://www.digitalocean.com/) for hosting on $18 Basic / 2 GB / 2 vCPUs
