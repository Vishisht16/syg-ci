# syg-ci

The continuous integration of [Syg](https://github.com/vishisht16/syg), whose
source is private, from 2026-10-17 to 2026-10-24. It now runs in Syg's own
repository: its `ci`, `watch` and `chaos` workflows, which report to the
source as the commit status `ci`.

Nothing here runs on a schedule any more. `ci` and `chaos` can still be
started by hand until this repository is archived, and their runs' history
stays here.

While it ran here, a job's output never reached the log: it was encrypted with
[age](https://age-encryption.org) to a key kept with the source, and uploaded
as an artifact of the run; the log said only whether the job passed.
