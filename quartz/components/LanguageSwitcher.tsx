import { QuartzComponent, QuartzComponentConstructor } from "./types"
// @ts-ignore
import script from "./scripts/languageSwitcher.inline"
import style from "./styles/languageSwitcher.scss"

const LanguageSwitcher: QuartzComponent = () => {
  // Initial hrefs are set as safe defaults.
  // The inline script overwrites them with the correct page-specific URL after nav.
  return (
    <div class="language-switcher">
      <a class="lang-btn active" data-lang="de" href="/" aria-label="Deutsch">
        DE
      </a>
      <span class="lang-divider">|</span>
      <a class="lang-btn" data-lang="en" href="/en" aria-label="English">
        EN
      </a>
    </div>
  )
}

LanguageSwitcher.afterDOMLoaded = script
LanguageSwitcher.css = style
export default (() => LanguageSwitcher) satisfies QuartzComponentConstructor
