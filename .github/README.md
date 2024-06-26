# Forked Repository: react-native-video

## Description
This repository is a fork of the original [react-native-video](https://github.com/react-native-video/react-native-video) repository. 

## Update Instructions
To sync this fork with the upstream repository, follow these steps:
1. Sync fork with the latest changes from the original repo
    - a. `git checkout master`
    - c. `git pull`
    - b. `git pull upstream` or `git merge [versionTag]`
    - d. `git push`
2. Update release branch with latest changes
    - a. `git checkout release`
    - b. `git pull`
    - b. `git checkout -b sync/v6.0.0-beta.5`
    - c. `git merge master`
    - d. Resolve conflicts
3. Create new PR targeting release branch
    - a. Name the PR `[v6.0.0 beta.8] Sync fork up to commit <commitHash>`
4. Review and merge PR
5. Draft a new release on GitHub
6. Update GolfPass apps package.json use the new version tag

## Commit Instructions
- from the release branch create a feature branch
   - `git checkout -b "feature/appletv-descriptive-name"`
       - prefix with `[ios/appletv/android/androidtv]-decriptive-name`
- Prefix all commits with [iOS/AppleTV/Android/AndroidTV]

## Tech Debt
- Remove _fork from function names as it creates more work if we want to PR this to the react-native-video team.
   -  Add Fork comments above these functions instead

## Changes Introduced By Fork
- [Specify the changes introduced with this fork here]

## README.md for the latest synced upstream
[Click here](/README.md) to visit the root README file of this repository.
