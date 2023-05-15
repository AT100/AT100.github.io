#!/bin/sh

. $(find $CONF_FOLDER -maxdepth 3 -type f -name "my_shell_colors")

script_name=$(basename "${0}")

# --------------------------------------------------------------------------------

# get script name
program="${0##*/}"

# figure out what directory your script is in
working_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# -----------------------------------------------------------------------------

my_error () {
  my_bell.sh
  printf "%b--------------------------------------%b\n" "$red_bg" "$normal"
  printf "%b%s%b\n"                                     "$flash_red_bg" "$1" "$normal"
  printf "%b--------------------------------------%b\n" "$red_bg" "$normal"
}

cd ${working_dir}

for run in {1..2}; do
  pdflatex -halt-on-error ${working_dir}/main.tex

  # check to make sure document compiled correctly
  if [ $? -ne 0 ]; then
    my_error "ERROR: $program failed to compile! Exiting..."
    exit 1
  fi
done

rm main.aux main.log main.nav main.out main.snm main.toc 

if ps cax | grep --silent mupdf; then
  printf "\n--> %s\n" "mupdf is running, asking it to refresh"
  killall -s SIGHUP mupdf
fi
