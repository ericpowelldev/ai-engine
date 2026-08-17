# System Gotchas

<!-- Durable facts that make "should work" behavior fail — checked when debugging the
     inexplicable. Knowledge is FACT-shaped ("X works like Y"), present tense,
     standalone, and includes the consequence that makes it worth knowing.
     Rule-shaped entries ("do X") belong in rules/ instead. -->

Example entry (replace with your own):

## The staging database resets nightly

The staging environment restores from a production snapshot every night at 02:00 UTC — any test data created during the day disappears, so an integration test that passed yesterday can fail this morning for no code reason. Seed required fixtures at test setup, never rely on data surviving across days.
