#!/usr/bin/env bash

echo "Setting up Node"

# Install yarn
curl -o- -L https://yarnpkg.com/install.sh | bash

# Install dependencies
yarn global add n
