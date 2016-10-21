# thomass/git-commit-generator

This docker image is creating a fake git repository with fake commits in the past.
This is useful, if you need an example repository for scientific research.

## usage

Run a bash inside the container. If you want to push the fake repository, you
will probably mount your .ssh credentials.

    docker run -it --rm \
      -v /home/user/.ssh:/root/.ssh \
      thomass/git-commit-generator bash

Inside the container execute the `./create-commits.sh`. This will result in a new
fake repository with fake commits. Enter `git log` to watch them.

## configuration

You can run the script with preceeding environment variables like:

    MIN_MOD_LINEAR='+3600' MAX_MOD_LINEAR='+3600' ./create-commits.sh

Following variables are available

| variable | default | description |
|----------|---------|-------------|
| FIRST_COMMIT_SINCE | 31536000 (1 year ago) | The seconds passed since the first commit. |
| LAST_COMMIT_SINCE | 0 (now) | The seconds passed since the last commit. |
| MIN_SHIFT | 10 | The initial minimum distance between two commits. |
| MAX_SHIFT | 86400 (1 day) | The initial maximum distance between two commits. |
| MIN_MOD_LINEAR | '+0' | The seconds added (+) or removed (-) to/from MIN_SHIFT after every commit. |
| MAX_MOD_LINEAR | '+0' | The seconds added (+) or removed (-) to/from MAX_SHIFT after every commit. |
| MIN_MOD_FACTOR | 1 | The factor MIN_SHIFT is modified after every commit. |
| MAX_MOD_FACTOR | 1 | The factor Max_SHIFT is modified after every commit. |

## Licence

MIT License

Copyright (c) 2016 Thomas Steinbach

The commit messages are from https://github.com/ngerakines/commitment
with MIT licence by 2010 Nick Gerakines

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
