# botmaker-gallery

The index of published BotMaker bots. Each entry is a pointer to somebody's own GitHub repository; the
release you install comes from *there*, never from here.

## Layout

```
bots/<owner>-<repo>.json    the source of truth — one entry per bot
index.json                  GENERATED. Committed by CI on merge. Do not edit it
tools/build-index.sh        how index.json is generated
```

**`index.json` never moves.** BotMaker Studio reads it from
`raw.githubusercontent.com/LiQiyeDev/botmaker-gallery/main/index.json`, and every already-shipped Studio has
that URL compiled into it. The generated array is byte-compatible with the single file it replaced, so
browsing and installing are unaffected.

**Publishing changed, though.** Studio now writes `bots/<owner>-<repo>.json`; a Studio old enough to rewrite
the whole array will have its pull request refused, naming the update. That is deliberate — the alternative
was a conversion job in CI, which means maintaining both shapes indefinitely.

Two things follow from one file per entry, and both were bought from the shared array:

- **Two authors publishing on the same day open two pull requests with no line in common.** An entry appended
  to a shared array conflicts with every other submission.
- **Delisting is a one-line deletion.** Removing a bot used to rewrite the file, so the diff a maintainer had
  to review was the whole gallery.

## An entry

```json
{
  "name": "Update",
  "owner": "LiQiyeDev",
  "repo": "Update",
  "description": "",
  "tags": [],
  "launchTargets": ["heroic"]
}
```

No version: the release to install is fetched live from the author's own repository, so a new release never
needs an edit here. `launchTargets` is what the author says their bot runs on; an entry without it reads as
"the author never said", never "works on nothing".

## Submitting

Publish from Studio (**Project ▸ Publish…**, with *List in the public gallery* ticked) — it forks this
repository, writes your entry file and opens the pull request. By hand, add `bots/<owner>-<repo>.json` with
the shape above.

This is a curated index, not a review of anybody's code: a bot is a Java program you build and run.
