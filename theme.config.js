// theme.config.js
export default {
  github: "https://github.com/brendenvogt",
  projectLink: "https://github.com/brendenvogt/next-docs-starter",
  docsRepositoryBase:
    "https://github.com/brendenvogt/next-docs-starter/tree/master",
  titleSuffix: " – Sample Docs Site",
  nextLinks: true,
  prevLinks: true,
  search: true,
  customSearch: null,
  darkMode: true,
  footer: true,
  footerText: `${new Date().getFullYear()} © Sample Docs Site`,
  footerEditLink: `Edit this page on GitHub`,
  logo: (
    <>
      <span>Test Docs</span>
    </>
  ),
  head: (
    <>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description" content="Sample Docs Site" />
      <meta name="og:title" content="Sample Docs Site" />
    </>
  ),
};
