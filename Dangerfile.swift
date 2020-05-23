import Danger
let danger = Danger()

let prDestination = danger.bitbucketCloud.pr.destination.branchName
let prTitle = danger.bitbucketCloud.pr.title
let prDescription = danger.bitbucketCloud.pr.description

let modifiedFiles = danger.git.modifiedFiles
let createdFiles = danger.git.createdFiles
let deletedFiles = danger.git.deletedFiles

// Sometimes it's a README fix, or something like that - which isn't relevant for
// including in a project's CHANGELOG for example
let declared_trivial = danger.bitbucketCloud.pr.title.contains("trivial")

// Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if prTitle.contains("WIP") {
  warn("PR is classed as Work in Progress")
}

// Warn about develop and master branch
if prDestination != "develop" || prDestination != "master" {
  warn("Please target PRs to `develop` or `master` branch")
}

// Warn summary on pull request
if prDescription.count < 5 {
  warn("Please provide a summary in the Pull Request description")
}

// If these are all empty something has gone wrong, better to raise it in a comment
if modifiedFiles.isEmpty, createdFiles.isEmpty, deletedFiles.isEmpty {
  fail("This PR has no changes at all, this is likely a developer issue.")
}

SwiftLint.lint(inline: true, configFile: ".swiftlint.yml", strict: true)

if !danger.git.modifiedFiles.filter({ $0.contains("Cartfile") }).isEmpty {
  message("Cartfile changed")
}

// Warn Cartfile changes
if !danger.git.modifiedFiles.filter({ $0.contains("Cartfile") }).isEmpty {
  message("Cartfile.resolved changed")
}
