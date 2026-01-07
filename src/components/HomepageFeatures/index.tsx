import type { ReactNode } from 'react';
import type React from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: ReactNode;
};

// Docusaurus requires CommonJS require() for static assets
/* eslint-disable @typescript-eslint/no-require-imports */
const mountainSvg =
  require('@site/static/img/undraw_docusaurus_mountain.svg').default;
const treeSvg = require('@site/static/img/undraw_docusaurus_tree.svg').default;
const reactSvg =
  require('@site/static/img/undraw_docusaurus_react.svg').default;
/* eslint-enable @typescript-eslint/no-require-imports */

const FeatureList: FeatureItem[] = [
  {
    title: 'Easy to Use',
    Svg: mountainSvg,
    description: (
      <>
        Docusaurus was designed from the ground up to be easily installed and
        used to get your website up and running quickly.
      </>
    ),
  },
  {
    title: 'Focus on What Matters',
    Svg: treeSvg,
    description: (
      <>
        Docusaurus lets you focus on your docs, and we&apos;ll do the chores. Go
        ahead and move your docs into the <code>docs</code> directory.
      </>
    ),
  },
  {
    title: 'Powered by React',
    Svg: reactSvg,
    description: (
      <>
        Extend or customize your website layout by reusing React. Docusaurus can
        be extended while reusing the same header and footer.
      </>
    ),
  },
];

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map(({ title, Svg, description }, idx) => (
            <div key={idx} className={clsx('col col--4')}>
              <div className="text--center">
                <Svg className={styles.featureSvg} role="img" />
              </div>
              <div className="text--center padding-horiz--md">
                <Heading as="h3">{title}</Heading>
                <p>{description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
