# /etc/profile resets PATH for login shells, so re-add the image's tool dirs
export PATH="$PATH:/usr/local/go/bin:/root/go/bin:/usr/share/dotnet:/root/.dotnet/tools"

# Each key of the herdr-env Secret becomes an env var

if [ -d /run/secrets/herdr-env ]; then
  for f in /run/secrets/herdr-env/*; do
    [ -f "$f" ] && export "$(basename "$f")=$(cat "$f")"
  done
  unset f
fi
