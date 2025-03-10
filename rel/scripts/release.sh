mix deps.get --only prod
mix compile
mix phx.digest.clean --all
mix assets.deploy
mix release --overwrite
_build/prod/rel/keele_codes/bin/keele_codes eval "KeeleCodes.Release.migrate"
systemctl stop keele-codes
systemctl start keele-codes
