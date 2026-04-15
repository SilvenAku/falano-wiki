import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

const config: QuartzConfig = {
  configuration: {
    pageTitle: "Falano Universe",
    pageTitleSuffix: " · Falano Universe",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "plausible",
    },
    locale: "de-DE",
    baseUrl: "wiki.falano-universum.de",
    ignorePatterns: [
      "private",
      "ZZ Templates",
      ".obsidian",
      "copilot",
      "Ideas",
      ".trash",
      "Tags",
    ],
    defaultDateType: "modified",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        header: "Cinzel",
        body: "Lato",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#f5f0e8",
          lightgray: "#ddd8cc",
          gray: "#a09880",
          darkgray: "#3a3228",
          dark: "#1a1410",
          secondary: "#7b5e2a",
          tertiary: "#c4973a",
          highlight: "rgba(196, 151, 58, 0.12)",
          textHighlight: "#f0d06088",
        },
        darkMode: {
          light: "#0f0e14",
          lightgray: "#1e1c28",
          gray: "#4a4760",
          darkgray: "#c8c4d8",
          dark: "#e8e4f4",
          secondary: "#9b7fd4",
          tertiary: "#c4973a",
          highlight: "rgba(155, 127, 212, 0.15)",
          textHighlight: "#c4973a55",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "git", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.Favicon(),
      Plugin.NotFoundPage(),
      Plugin.CustomOgImages(),
    ],
  },
}

export default config
