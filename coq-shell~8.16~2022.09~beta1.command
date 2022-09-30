#!/bin/sh

echo "============================== COQ SHELL =============================="

# Find Coq and put it into the path
if ! [ -f /Applications/Coq-Platform~8.16~2022.09~beta1.app/Contents/Resources/bin/coqc ]
then
  echo "This script expects that Coq is installed in"
  echo "/Applications/Coq-Platform~8.16~2022.09~beta1.app/"
  exit 1
else
  echo "Using coqc and tools from:"
  echo "/Applications/Coq-Platform~8.16~2022.09~beta1.app/Contents/Resources/bin"
  export PATH='/Applications/Coq-Platform~8.16~2022.09~beta1.app/Contents/Resources/bin':"$PATH"
fi

# Set COQLIB variable
export COQLIB="$(coqc -where | tr -d '\r')"

echo "============================== COQ SHELL =============================="

# Run prefeed shell of user in interactive mode
$SHELL -i
