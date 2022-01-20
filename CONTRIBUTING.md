<img src="https://avatars.githubusercontent.com/u/96331755?s=400&u=ecfc62f34d671b06f9411e2a3d99e12cf30acd99&v=4">

### Go ahead, make this thing even better!

# Contributing guidelines

I :heart: [Pull Requests](https://help.github.com/articles/about-pull-requests/)
for fixing issues or adding features. Thanks for your contribution!

For small changes, especially documentation, you can simply use the "Edit" button
to update the Markdown file, and start the
[pull request](https://help.github.com/articles/about-pull-requests/) process.
Use the preview tab in GitHub to make sure that it is properly
formatted before committing.
A pull request will cause integration tests to run automatically, so please review
the results of the pipeline and correct any mistakes that are reported.

If you plan to contribute often or have a larger change to make, it is best to
setup an environment for contribution, which is what the rest of these guidelines
describe.

## Development Environment Setup


### Prerequisites

You'll need to have [Docker installed](https://docs.docker.com/get-docker/)
if you'd like to build images locally.

### GitHub Repository Clone

To prepare your dedicated GitHub repository:

1. Fork in GitHub https://github.com/atsign-foundation/REPO
2. Clone *your forked repository* (e.g., `git clone git@github.com:yourname/at_dockerfiles`)
3. Set your remotes as follows:

   ```sh
   cd REPO
   git remote add upstream git@github.com:atsign-company/at_dockerfiles.git
   git remote set-url upstream --push DISABLED
   ```

   Running `git remote -v` should give something similar to:

   ```text
   origin  git@github.com:yourname/at_dockerfiles.git (fetch)
   origin  git@github.com:yourname/at_dockerfiles.git (push)
   upstream        git@github.com:atsign-foundation/REPO.git (fetch)
   upstream        DISABLED (push)
   ```

   The use of `upstream --push DISABLED` is to prevent those
   with `write` access to the main repository from accidentally pushing changes
   directly.
   
### Development Process

1. Fetch latest changes from main repository:

   ```sh
   git fetch upstream
   ```

1. Reset your fork's `master` branch to exactly match upstream `master`:

   ```sh
   git checkout master
   git reset --hard upstream/master
   git push --force
   ```

   **IMPORTANT**: Do this only once, when you start working on new feature as
   the commands above will completely overwrite any local changes in `master` content.
1. Edit, edit, edit, and commit your changes to Git:

   ```sh
   # edit, edit, edit
   git add *
   git commit -m 'A useful commit message'
   git push
   ```

1. Open a new Pull Request to the main repository using your `master` branch