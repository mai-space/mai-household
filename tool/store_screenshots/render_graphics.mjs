// Erzeugt Store-Icon (512×512) und Feature-Grafik (1024×500) unter
// store/android/ aus dem App-Logo und den Screenshots.
//
// Aufruf (nach store_screenshots_test.dart, aus dem Repo-Wurzelordner):
//   ROBOTO_DIR=<flutter>/bin/cache/artifacts/material_fonts \
//     node tool/store_screenshots/render_graphics.mjs
// Benötigt Playwright mit Chromium.
import { chromium } from 'playwright';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const out = resolve('store/android');
const fonts = process.env.ROBOTO_DIR;
const b64 = (p) => readFileSync(p).toString('base64');

// Logo ohne abgerundete Ecken und mit etwas Rand: Google Play rundet das
// Icon selbst ab und schneidet dabei an den Ecken.
const logo = readFileSync('assets/branding/logo.svg', 'utf8')
  .replace('viewBox="14 14 80 80"', 'viewBox="4 4 100 100"')
  .replace('x="14" y="14" width="80" height="80" rx="20"', 'x="0" y="0" width="108" height="108"');
const logoUri = `data:image/svg+xml;base64,${Buffer.from(logo).toString('base64')}`;
const roundedLogoUri = `data:image/svg+xml;base64,${b64('assets/branding/logo.svg')}`;

const fontFace = fonts
  ? ['Regular:400', 'Medium:500', 'Bold:700', 'Black:900']
      .map((s) => {
        const [name, weight] = s.split(':');
        return `@font-face{font-family:R;font-weight:${weight};src:url(data:font/ttf;base64,${b64(`${fonts}/Roboto-${name}.ttf`)})}`;
      })
      .join('')
  : '';

const texts = {
  de: ['Haushalt', 'Einkauf, Aufgaben und Küche', 'gemeinsam – ohne Konto, ohne Cloud'],
  en: ['Haushalt', 'Shopping, chores and cooking', 'together – no account, no cloud'],
};

const feature = (lang) => {
  const [title, line1, line2] = texts[lang];
  const shot = (n) =>
    `data:image/png;base64,${b64(`store/android/screenshots/${lang}/${n}.png`)}`;
  return `<!doctype html><html><head><style>${fontFace}
  *{margin:0;box-sizing:border-box}
  body{width:1024px;height:500px;overflow:hidden;font-family:R,sans-serif;
    background:linear-gradient(135deg,#6BAF7F 0%,#3E7C59 100%);position:relative;color:#fff}
  .left{position:absolute;left:64px;top:0;bottom:0;display:flex;flex-direction:column;justify-content:center;width:520px}
  .left img{width:112px;height:112px;margin-bottom:28px;filter:drop-shadow(0 6px 16px rgba(0,0,0,.25))}
  h1{font-weight:900;font-size:68px;letter-spacing:-1px;margin-bottom:14px}
  p{font-size:30px;font-weight:500;line-height:1.3}
  p.sub{font-weight:400;opacity:.9;font-size:26px}
  .phone{position:absolute;width:250px;border-radius:26px;overflow:hidden;
    border:7px solid #1d2b22;box-shadow:0 18px 40px rgba(0,0,0,.35);background:#1d2b22}
  .phone img{display:block;width:100%}
  .p1{left:600px;top:60px;transform:rotate(-6deg)}
  .p2{left:770px;top:110px;transform:rotate(5deg)}
  </style></head><body>
  <div class="left"><img src="${roundedLogoUri}"><h1>${title}</h1><p>${line1}</p><p class="sub">${line2}</p></div>
  <div class="phone p1"><img src="${shot('02_shopping')}"></div>
  <div class="phone p2"><img src="${shot('04_chores')}"></div>
  </body></html>`;
};

const browser = await chromium.launch(
  process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {},
);
const page = await browser.newPage();

await page.setViewportSize({ width: 512, height: 512 });
await page.setContent(
  `<style>*{margin:0}body{width:512px;height:512px}</style><img src="${logoUri}" width="512" height="512">`,
);
await page.screenshot({ path: `${out}/icon_512.png`, omitBackground: false });

await page.setViewportSize({ width: 1024, height: 500 });
for (const lang of ['de', 'en']) {
  await page.setContent(feature(lang));
  await page.screenshot({ path: `${out}/feature_graphic_${lang}.png` });
}
await browser.close();
