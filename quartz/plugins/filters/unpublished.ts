import { QuartzFilterPlugin } from "../types"

// Blendet Seiten aus, bei denen `published: false` in den Frontmatter-Properties gesetzt ist.
// Standard (kein Property oder `published: true`) → Seite ist sichtbar.
// `published: false` → Seite wird nicht gerendert und erscheint nicht im Wiki.
export const RemoveUnpublished: QuartzFilterPlugin<{}> = () => ({
  name: "RemoveUnpublished",
  shouldPublish(_ctx, [_tree, vfile]) {
    const publishedFlag = vfile.data?.frontmatter?.published
    // Nur explizit auf false gesetzt → ausblenden
    if (publishedFlag === false || publishedFlag === "false") return false
    return true
  },
})
