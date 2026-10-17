# syg-ci

The continuous integration of [Syg](https://github.com/vishisht16/syg), whose
source is private, on GitHub's runners: its tests on Linux, macOS and Windows,
the lint and fuzz job, the end-to-end suites on kind clusters (Kubernetes
1.30, 1.32 and 1.33), and a vulnerability scan.

A job's output never reaches the log. It is encrypted with
[age](https://age-encryption.org) to a key kept with the source, and uploaded
as an artifact of the run; the log says only whether the job passed. Runs are
started by hand, for a branch, tag or commit of the source, and weekly.
