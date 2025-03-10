git pull origin master
mix deps.get --only prod
mix compile
mix assets.deploy
mix ecto.migrate
mix release
_build/prod/rel/keele_codes/bin/keele_codes restart
