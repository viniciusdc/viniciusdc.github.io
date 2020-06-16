---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

title: Main Goals
layout: home
---

My goal creating this page is to:
1. Have different point of views of the structure of conda-forge;
2. Try to understand more about some fundamental concepts of the conda-forge auto-tick bot;
3. Know everyone better (if possible);
4. Share my current development into the issues and processes i am engaged;
5. Get more experience with the community to help even more.

My main questions will be stored in the issues section of this page, until I discover how to put a blog-answer style here.
Also, there will be my current state in the problem i am involved.

Current issue: `cf-graph-countyfair`/`cf-scripts`: [#842][i842];

Engaged on PR's: [#1027][p907], [#61][p61];

The [#1027] PR corresponds to the `new_update_upstream_versions` code as it separates the feedstocks sources into a new script called `update_sources.py` (There is also an modification at the `cli.xsh` file). 

The [#61] PR corresponds to an alteration at the `circle_worker` config (a new job header for the update versions code). It aims to save the versions outputs to an new file inside `cf-graph-countyfair` with the correspondents JSON files.

Last code: [#code][code];

Separeted repo for tests -- `ts-graph` -- Last test status from Circle CI [status].

If there is something you would like to comment or help me with, I will gratefully accept (you can comment here - issues) or send me a message on Gitter.

[i842]: https://github.com/regro/cf-scripts/issues/842
[p1027]: https://github.com/regro/cf-scripts/pull/1027
[p61]: https://github.com/regro/circle_worker/pull/61
[code]: https://github.com/regro/circle_worker/pull/61/commits/017344494e9e01c75efe312a6ba8323b37ff9fd3
[status]: https://app.circleci.com/pipelines/github/viniciusdc/ts-graph/46/workflows/cf6da52d-df5d-485d-9aaf-6c142ce10962/jobs/51/steps
