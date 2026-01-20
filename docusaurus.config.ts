import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'Bryce Seefieldt | Portfolio Documentation',
  tagline: 'Dev docs and resources for the development portfolio project',
  favicon: 'img/favicon2.png',

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  future: {
    v4: true, // Improve compatibility with the upcoming Docusaurus v4
  },

  // Set the production url of your site here
  url:
    process.env.DOCUSAURUS_SITE_URL || 'https://bns-portfolio-docs.vercel.app',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: process.env.DOCUSAURUS_BASE_URL || '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt', // Usually your GitHub org/user name.
  projectName: process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenAnchors: 'warn',

  // Custom fields for cross-repository linking
  customFields: {
    portfolioAppUrl:
      process.env.DOCUSAURUS_PORTFOLIO_APP_URL ||
      'https://bns-portfolio-app.vercel.app',
    githubOrgUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}`,
    githubRepoDocsUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs'}`,
    githubRepoAppUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_APP || 'portfolio-app'}`,
  },

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang.
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  themes: ['@docusaurus/theme-mermaid'],

  markdown: {
    mermaid: true,
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          // editUrl:
          //   'https://github.com/bryce-seefieldt/portfolio-docs/tree/main/',
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs'}/tree/main/`,
          // Useful options to enforce blogging best practices
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    mermaid: {
      theme: { light: 'default', dark: 'dark' },
    },
    // Replace with your project's social card
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'Portfolio Documentation',
      logo: {
        alt: 'Bryce Seefieldt Logo',
        src: 'img/seven30.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        // {to: '/blog', label: 'Blog', position: 'left'},
        {
          href: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/${process.env.DOCUSAURUS_GITHUB_REPO_DOCS || 'portfolio-docs'}`,
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Portfolio Documentation',
              to: '/docs',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/docusaurus',
            },
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/docusaurus',
            },
          ],
        },
        {
          title: 'More',
          items: [
            // {
            //   label: 'Blog',
            //   to: '/blog',
            // },
            {
              label: 'GitHub',
              href: `https://github.com/${process.env.DOCUSAURUS_GITHUB_ORG || 'bryce-seefieldt'}/`,
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Bryce Seefieldt. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
