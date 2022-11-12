# 0.1.2

- S-kaupat had changed a bit their order summary page -> fixed the HTML parsing of S-kaupat.
    - Especially product price, quantity and name had changed.
    - In the current S-kaupat HTML file the packaging material payment and the home delivery don't have quantity divs anymore.
- Update API docs.
- Fix S-kaupat example HTML file to fix tests.

## 0.1.1

- Fix two pub publish warnings:
    - rename LICENSE.md to LICENSE and
    - change excel dependency to flutter_excel (a prerelease versus a stable release).

## 0.1.0

- Add a minimum viable product (MVP). It includes:
    - a Kassakuitti instance,
    - read a text file containing receipt products (only for S-kaupat),
    - read an HTML file containing EAN products (for both S-kaupat and K-ruoka) and
    - export both product types into CSV or Excel (XLSX) file based on the choice.
