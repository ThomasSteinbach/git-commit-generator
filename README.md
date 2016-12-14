# thomass/git-commit-generator

This docker image is creating a fake git repository with fake commits in the past.
This is useful, if you need an example repository for scientific research.

## usage

Run a bash inside the container. If you want to push the fake repository, you
will probably mount your .ssh credentials.

    docker run -it --rm -v /home/user/.ssh:/home/uid1000/.ssh thomass/git-commit-generator bash

Inside the container execute the `create-commits`. This will result in a new
fake repository with fake commits. Enter `git log` in the repository directory
under `/tmp/...` to watch them.

## add initial data

Mount the initial data to the `/workspace` directory inside the container.

    docker run -it --rm \
      -v /path/to/local/data:/workspace \
      ...

## configuration

You can run the script with preceeding environment variables like:

    MIN_MOD_LINEAR='+3600' MAX_MOD_LINEAR='+3600' create-commits

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

## variable commits for paths

You can create a different commit behavior for different paths within your repository.
The paths must exist within the workspace. To do so:

Create a file with two columns separated by semicolon where the first column is
the path and the second column a value between 0 and 10000:

    /path/to/somewhere;8000
    /other/path/to/anywhere:4000
    /third/path/example;9500

Pass this file to the `create-commits` command (behind).

After every commit to the root of the repository a number between 1 and 10000 is
randomly chosen. If the number in your file behind each path is greater than the
random number, also a commit to this path is made.

The lower limit can be modified after every turn:

| variable | default | description |
|----------|---------|-------------|
| PATH_MOD_LINEAR | 0 | This number is added after each round to the lower limit. |
| PATH_MOD_FACTOR | 1 | After each round the lower limit is multiplied by this number. |

Example:

    PATH_MOD_FACTOR=1.01 PATH_MOD_LINEAR=3 create-commits /workspace/commit_paths.txt

## examples

Here are three example repositories with different settings. You can watch the commit history and commit graph there.

| settings | repository |
|----------|------------|
| FIRST_COMMIT_SINCE=15768000 LAST_COMMIT_SINCE=2678400 MIN_MOD_FACTOR=1 MAX_MOD_FACTOR=1.1 | https://github.com/ThomasSteinbach/application01 |
| FIRST_COMMIT_SINCE=15768000 LAST_COMMIT_SINCE=2678400 MAX_SHIFT='3600' MIN_MOD_LINEAR='+14400' MAX_MOD_LINEAR='+28800' | https://github.com/ThomasSteinbach/application02 |
| default settings | https://github.com/ThomasSteinbach/application03 |

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
