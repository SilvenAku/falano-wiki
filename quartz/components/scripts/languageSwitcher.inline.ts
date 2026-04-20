document.addEventListener("nav", () => {
  const path = window.location.pathname
  const isEnglish = path === "/en" || path === "/en/" || path.startsWith("/en/")

  const deBtn = document.querySelector('.lang-btn[data-lang="de"]') as HTMLAnchorElement
  const enBtn = document.querySelector('.lang-btn[data-lang="en"]') as HTMLAnchorElement
  if (!deBtn || !enBtn) return

  // Normalize: remove trailing slash unless root
  const normalizedPath = path.endsWith("/") && path.length > 1 ? path.slice(0, -1) : path

  if (isEnglish) {
    // On English page: DE = remove /en prefix
    const dePath = normalizedPath.replace(/^\/en/, "") || "/"
    deBtn.href = dePath
    enBtn.href = normalizedPath
  } else {
    // On German page: EN = add /en prefix
    deBtn.href = normalizedPath || "/"
    enBtn.href = "/en" + (normalizedPath === "/" ? "" : normalizedPath)
  }

  deBtn.classList.toggle("active", !isEnglish)
  enBtn.classList.toggle("active", isEnglish)
})
