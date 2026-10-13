# How to Write Release Notes

<!-- An example guide (replace with your own). A guide is a how-to for producing one kind
     of artifact, run through a thin command wrapper in wiring/commands/. It holds the
     procedure and any templates; it points at rules by name instead of restating them,
     and at scripts as the single source of whatever they own. Supporting docs a guide
     needs (references, templates too large to inline) can live in a subfolder named for
     the guide. Delete this file if the module has no guides yet. -->

How to write the release notes for a release: what changed, for the people who use the product. Run through `/<prefix>-release-notes`.

## Extension points

<!-- Optional. Declare the parts another module may extend; a module extends one in its
     own content/extensions/<command-name>.md, one ## section per point, marked adds or
     replaces. Leave this section out when nothing should be extensible. -->

- **Audience notes (adds):** extra audiences and what each needs called out.

## Steps

1. **Gather the changes** since the last release: <where they come from, e.g. merged pull requests or the changelog>.
2. **Group them** by what a user notices: new, improved, fixed.
3. **Write each entry** as the outcome for the user, following <the documenting rules that apply, by name>.
4. **Apply each active module's *Audience notes*.**
5. **Save** the notes at <where they live>, then report the path.

## Template

```markdown
# <Product> <version>: Release Notes

## New

- <what someone can now do>

## Improved

- <what works better, and how they'll notice>

## Fixed

- <what no longer goes wrong>
```
