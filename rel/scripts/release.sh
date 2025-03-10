mix deps.get --only prod
mix compile
mix assets.deploy
mix release --overwrite
_build/prod/rel/keele_codes/bin/keele_codes eval "KeeleCodes.Release.migrate"
_build/prod/rel/keele_codes/bin/keele_codes stop
_build/prod/rel/keele_codes/bin/keele_codes start
