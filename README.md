# syg-ci

The continuous integration of [Syg](https://github.com/vishisht16/syg), whose
source is private, on GitHub's runners: its tests on Linux, macOS and Windows,
the lint and fuzz job, the end-to-end suites on kind clusters (Kubernetes
1.30, 1.32 and 1.33), a vulnerability scan, and the documentation site, whose
latest build is the preview on this repository's Pages.

Every quarter of an hour, `watch` starts the CI for each commit it has not
tested: the source's default branch, and its Dependabot pull requests. The CI
also runs when started by hand, and weekly, and reports each commit's result
to the source as the commit status `syg-ci`.

A job's output never reaches the log. It is encrypted with
[age](https://age-encryption.org) to a key kept with the source, and uploaded
as an artifact of the run; the log says only whether the job passed.
