prefix="plugins/"

function checkoutPlugin() {
  for tag in $(svn list "https://plugins.svn.wordpress.org/$1/tags"); do
    [ ! -d "$prefix$1/$tag" ] || continue

    echo "$1/$tag"
    mkdir -p "$prefix$1/$tag"
    svn checkout "https://plugins.svn.wordpress.org/$1/tags/$tag" "$prefix$1/$tag" --depth empty -q
    svn up "$prefix$1/$tag/readme.txt" -q
    svn up "$prefix$1/$tag/README.txt" -q

    # If readme is uppercase, lowercase the filename (WSL-safe)
    [ -f "$prefix$1/$tag/README.txt" ] || continue
    mv "$prefix$1/$tag/README.txt" "$prefix$1/$tag/readme2.txt"
    mv "$prefix$1/$tag/readme2.txt" "$prefix$1/$tag/readme.txt"
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
listVersions "$1" "$2"
