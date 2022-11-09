# kassakuitti

A Dart package for handling a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).

Currently this package works best with a command-line interface (CLI). This means that it should work only with Windows, macOS and Linux.

## Features

- Read a text file containing receipt products (only for S-kaupat).
- Read an HTML file containing EAN products (for both S-kaupat and K-ruoka).
- Export both product types into CSV or Excel (XLSX) file based on the choice.

## Getting started

You need two files to use this package:
1. an HTML file containing EAN products when using S-kaupat or K-ruoka and 
2. a text file containing receipt products when using S-kaupat.

To get an HTML file, follow these instructions:
- Generate an HTML file by using `snapshot-as-html` project (see the [installation](https://github.com/areee/dart_kassakuitti_cli/blob/main/INSTALLATION.md)).
  - To generate that, go to an active order page of an online store:
    - [s-kaupat.fi](https://www.s-kaupat.fi) (profile image → "Tilaukset" → "Katso tilaustiedot") or
    - [k-ruoka.fi](https://www.k-ruoka.fi) (profile image → "Tilaukset" → expand the latest order).
  - Then click the `snapshot-as-html` extension image and click "Capture it!".
  - An HTML file will be generated and saved to your computer's Downloads folder.

To get a text file, follow these instructions:
- Ensure that you have enabled an electronic cash receipt service in S-kanava (a separate service for S-kaupat).
    - Go to [s-kanava.fi](https://www.s-kanava.fi) and select ["Kassakuitit" page](https://www.s-kanava.fi/web/s/oma-s-kanava/asiakasomistaja/kassakuitit).
    - Select a cash receipt you want to view. Select needed rows by painting from the first product row to the total row. Copy them.
    - Open a text editor (e.g. Notepad or TextEdit) and paste copied cash receipt rows. Save the file as a plain text file (.txt).

## Usage

```dart
/*
    Create a Kassakuitti instance using default values:
        selectedStore = selectedShop = SelectedShop.sKaupat
        selectedFileFormat = SelectedFileFormat.xlsx
*/
var kassakuitti = Kassakuitti('path/to/textFile.txt', 'path/to/htmlFile.html');
var receiptProducts = await kassakuitti.readReceiptProducts();
var eanProducts = await kassakuitti.readEANProducts();
var exportedFilePaths =
        await kassakuitti.export(receiptProducts, eanProducts);
```

## Additional information

This kassakuitti project set started from [dart_kassakuitti_cli](https://github.com/areee/dart_kassakuitti_cli) project in October 2021.

If you would like to contribute, please give an [issue](https://github.com/areee/kassakuitti/issues) to discuss about a problem.

Currently this project is authored by [Arttu Ylhävuori](https://www.linkedin.com/in/arttuylh).