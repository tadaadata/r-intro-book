You can suggest any kind of change you want to, but the larger the change, the more careful we need to be.

## Typos, spelling, grammar...

These minor changes can be done quikcly via the GitHub web-editor and submiited as a pull request with minimal comments.  
A fix for a typo should be immediately obvious given the diff, so no justification is required. Please keep related changes in one PR.

## Content

Larger changes to content should be discussed in an issue prior to any changes, and optionally in our internal Slack group.  
PRs that change larger sections of content without proper comments / explanations might be rejected unless appropriately discussed.

## Nitty gritty

Changes to the build system, i.e. bookdown options or other changes that don't change the content, but the generated output, 
are very delicate and should be rigorously tested to ensure we don't accidentally break all the things.  
PRs changing these internals are therefore discouraged, unless tested.
