prefix="plugins/"

OUTPUT_SUMMARY=true
LOG_OUTPUT=true
DOWNLOAD_PLUGIN_ARCHIVE=false
TRIM_LINES=0

if [ -f .env ];
then
  source .env
fi

function checkoutPlugin() {
  [ -d "$prefix$1" ] || svn checkout "https://plugins.svn.wordpress.org/$1/tags/" "$prefix$1" --depth empty -q

  for tag in $(svn list "https://plugins.svn.wordpress.org/$1/tags"); do
    tag=${tag%?}
    [ ! -d "$prefix$1/$tag" ] || continue

    if [ $LOG_OUTPUT == true ]; then
      echo "$1/$tag"
    fi

    svn up "$prefix$1/$tag" --depth empty -q > /dev/null
    svn up "$prefix$1/$tag/readme.txt" -q > /dev/null

    if [ ! -f "$prefix$1/$tag/readme.txt" ]; then
      # If readme is uppercase, lowercase the filename (WSL-safe)
      svn up "$prefix$1/$tag/README.txt" -q > /dev/null
      mv "$prefix$1/$tag/README.txt" "$prefix$1/$tag/readme2.txt" > /dev/null
      mv "$prefix$1/$tag/readme2.txt" "$prefix$1/$tag/readme.txt" > /dev/null
    fi

    if [ ! -f "$prefix$1/$tag/readme.txt" ]; then
      # If readme still is missing, maybe they use readme.md
      svn up "$prefix$1/$tag/readme.md" -q > /dev/null
      mv "$prefix$1/$tag/readme.md" "$prefix$1/$tag/readme.txt" > /dev/null
    fi

    if [ $TRIM_LINES -gt 0 ]; then
      trimmedContent=$(head -n $TRIM_LINES "$prefix$1/$tag/readme.txt")
      echo "$trimmedContent" > "$prefix$1/$tag/readme.txt"
    fi

    if [ $DOWNLOAD_PLUGIN_ARCHIVE == true ]; then
      curl -s "https://downloads.wordpress.org/plugin/$1.$tag.zip" -o "$prefix$1/$tag/plugin.zip" --fail

      curlExitCode=$?
      if [ ! $curlExitCode == 0 ] ; then
        echo "- Plugin download failed"
      fi
    fi
  done
}

function listVersions() {
  for f in $(find "$prefix$1" -maxdepth 1 -type d | grep "/$2" | sort --version-sort); do
    [ -f "$f/readme.txt" ] || continue

    echo "$f"
    svn info "$f" | grep "Changed Date"
    grep "Requires at least:" "$f/readme.txt"
    grep "Tested up to:" "$f/readme.txt"
    grep "Requires PHP:" "$f/readme.txt"
    echo " "
  done
}

checkoutPlugin "$1"

if [ $OUTPUT_SUMMARY == true ]; then
  listVersions "$1" "$2"
fi
