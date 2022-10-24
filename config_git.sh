#!/bin/bash

git config --global user.name $1
git config --global user.email 'dobler.carlos@gmail.com'

git config --global credential.helper 'cache --timeout=10000000'

git config --global --list
