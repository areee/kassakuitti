## 0.5.0

- Fix an HTML parsing bug with handling an S-kaupat HTML file. One extra div was added there (again).
- Update S-kaupat example HTML file (to fix broken tests).
- Update one dependency & update Dart SDK version to the latest stable Flutter version (Dart 2.19.6).

## 0.4.1

- Fix an HTML parsing bug with handling an S-kaupat HTML file. One extra div was removed.
- Update S-kaupat example HTML file (to fix broken tests).

## 0.4.0

- Fix an HTML parsing bug with handling an S-kaupat HTML file. One extra div was added there (again).
- Update one dependency & update Dart SDK version to the latest stable Flutter version (Dart 2.19.4).

## 0.3.0

- Merge with changes in the prerelease version (1.0.0-dev.2).
  - Update Dart SDK & dependencies.
  - Fix a bug: if there's a row containing a word "tasaerä" ("equal instalment"), skip it.
- Update Dart SDK version to the latest stable Flutter version (Dart 2.19.2)
- Fix an HTML handling bug with handling an S-kaupat HTML file. One extra div was added there.

## 0.2.2

- S-kaupat had changed their price field in the EAN products. Now it's again a total price, not a unit price as it was for some weeks (compare to version 0.1.3 changes).
- Fix S-kaupat example file.
- Update API docs (nothing but the version number has changed).

## 0.2.1

- Fix a case where a receipt product row had mistakenly two whitespaces between the name parts. An example: "Juusto 10%".
  - Now it allows even three whitespaces between them. Starting with four whitespaces it can be assumed that it's a separator between the name and the total price.

## 0.2.0

- When a product has a counted discount, do not show a boolean value but a 'yes' string and a yellow background in the row of an Excel / XLSX file.
- Fix an HTML file parsing into EAN products when a quantity field has a decimal instead of an integer (e.g. 0,6 instead of 1).
- Fix a text file parsing into receipt products. Earlier was 8–35 whitespaces between a "normal" product name and total price, but e.g. 6 whitespaces didn't get splitted. Now all whitespaces beginning from 2 whitespaces are supported.
- Enhance test coverage a bit.
- Fix some changelog header levels.

## 0.1.3

- A bug: currently, S-kaupat HTML file has a price per unit as a price for a product, not a total price as earlier. Fix the parsing logic of S-kaupat HTML file.
- Fix 'Reading receiptProducts work' test.
- Small price fixes into cash receipt example & S-kaupat HTML example.

## 0.1.2

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
