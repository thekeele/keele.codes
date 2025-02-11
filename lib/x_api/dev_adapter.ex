defmodule XApi.DevAdapter do
  @moduledoc false

  def recent_tweets() do
    recent_tweets_stub()["data"]
  end

  defp recent_tweets_stub() do
    %{
      "data" => [
        %{
          "text" =>
            "RT @Cointelegraph: 🚨 JUST IN: North Carolina has introduced a strategic #Bitcoin reserve bill, aiming to become the first U.S. state to buy…"
        },
        %{
          "text" =>
            "@chickenkungpao5 @BitcoinPuppets @nodemonkes @dmtnatcats @Pizza_Pets @Bitcoin_Punks_ @LeonidasNFT gm cutie ☺️"
        },
        %{
          "text" =>
            "RT @WatcherGuru: JUST IN: 🇭🇰 Hong Kong officially recognizes Bitcoin &amp; Ethereum as part of its investment visa program."
        },
        %{
          "text" =>
            "@truthscant @ShieldsClips BAN Fraud printing DOLLARS. CON Trump is a  sell out Zionist Traitor, He just loves fraud Money. when will you wake my dear Col.  Douglas. In fact you also fell in love with his BITCOIN CRYPTO PONZI Scheme. I have zero response from ourcountryourchoice? https://t.co/Owl0snFsLy"
        },
        %{
          "text" =>
            "RT @Kasfinex: Satoshi's dream came true with #Kaspa.\n$KAS\n#Bitcoin #Crypto #Ethereum #Altcoins https://t.co/2lHWUnB2v6"
        },
        %{
          "text" =>
            "RT @BitcoinPepe_: 🚨 $900,000 RAISED IN LESS THAN 3 HOURS 🚨\n\nFrens, we are officially closing in on the $1M mark and we are only 3 HOURS int…"
        },
        %{
          "text" =>
            "RT @bitcoinwizardry: Huge Giveaway! 🎁 🥳\n\nMagic Internet Money is launching soon so we're doing a giveaway 🪄\n\n5x WL spots for our 10k Bitcoi…"
        },
        %{
          "text" =>
            "SHOCKING 😳\n\nIn January, Binance Sold 94% of its #Bitcoin reserves, 99.9% of $ETH, and 99% of $SOL—all from profits, not customer funds, according to analyst @_FORAB https://t.co/hQXfIIuV1O"
        },
        %{
          "text" =>
            "RT @borsaressami: Şu tabloya bakınca dört damarım birden tıkanıyor resmen. \n\nYeni listelenen koinler ile bir aşağı bir yukarı takılıyorlar…"
        },
        %{
          "text" =>
            "Gold hitting new highs while Bitcoin just moves sideways. Be patient, the time will come"
        }
      ],
      "meta" => %{}
    }
  end
end
