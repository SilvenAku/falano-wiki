import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
// @ts-ignore
import style from "./styles/languageSwitcher.scss"

const LanguageSwitcher: QuartzComponent = ({ fileData }: QuartzComponentProps) => {
  const slug = fileData.slug ?? ""
  const isEnglish = slug === "en" || slug.startsWith("en/")

  // Equivalent page in the other language
  const deUrl = isEnglish ? "/" + (slug === "en" ? "" : slug.slice(3)) : "/" + slug
  const enUrl = isEnglish ? "/" + slug : "/en/" + (slug === "index" ? "" : slug)

  return (
    <div class="language-switcher">
      <a href={deUrl} class={`lang-btn${!isEnglish ? " active" : ""}`} aria-label="Deutsch">
        DE
      </a>
      <span class="lang-divider">|</span>
      <a href={enUrl} class={`lang-btn${isEnglish ? " active" : ""}`} aria-label="English">
        EN
      </a>
    </div>
  )
}

LanguageSwitcher.css = style
export default (() => LanguageSwitcher) satisfies QuartzComponentConstructor
