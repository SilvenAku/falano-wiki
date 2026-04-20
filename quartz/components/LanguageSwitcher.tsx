import { QuartzComponent, QuartzComponentConstructor } from "./types"
// @ts-ignore
import script from "./scripts/languageSwitcher.inline"
import style from "./styles/languageSwitcher.scss"

const LanguageSwitcher: QuartzComponent = () => {
  return (
    <div class="language-switcher">
      <a class="lang-btn" data-lang="de" aria-label="Deutsch">
        DE
      </a>
      <span class="lang-divider">|</span>
      <a class="lang-btn" data-lang="en" aria-label="English">
        EN
      </a>
    </div>
  )
}

LanguageSwitcher.afterDOMLoaded = script
LanguageSwitcher.css = style
export default (() => LanguageSwitcher) satisfies QuartzComponentConstructor
