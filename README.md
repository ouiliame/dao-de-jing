# Daodejing Typesetting Project

A modern digital typesetting system for the Daodejing (道德經), featuring parallel Chinese text and English calques. This project uses Typst for layout and formatting, with XML for structured content storage.

## Features

- Bilingual display with Chinese characters and English calques
- Clean, modern typography with customizable fonts
- Chapter-by-chapter XML storage for easy maintenance
- Configurable layout and styling
- Support for textual annotations and variants

## Setup

1. Install required software:

   - [Typst](https://typst.app/)
   - Python 3.6+
   - Required fonts:
     - Songti SC (Chinese)
     - Your preferred English font (default: Proxima Nova)

2. Generate chapter files:

   ```bash
   python scripts/process_chapters.py
   ```

3. Compile the document:
   ```bash
   typst compile daodejing.typ
   ```

## Configuration

### Fonts

Edit the font settings in `daodejing.typ`:

```typst
#let chinese-font = ("Songti SC")
#let english-font = ("Proxima Nova")
```

### Layout

Adjust page margins and spacing in `daodejing.typ`:

```typst
#set page(
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)
```

## XML Structure

Each chapter is stored in a separate XML file with the following structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<chapter number="1">
    <line>
        <word original="道" calque="way"/>
        <word original="可" calque="can"/>
        <!-- ... -->
    </line>
    <!-- ... -->
</chapter>
```

## Processing Scripts

### process_chapters.py

Converts the source text into individual XML chapter files:

```bash
python process_chapters.py
```

Features:

- Splits text into chapters
- Processes special annotations
- Handles textual variants
- Creates structured XML output

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Text Sources

The Chinese text is based on traditional sources with careful consideration of textual variants. English calques are provided for reference and study purposes.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Traditional Chinese fonts provided by respective type foundries
- Text sources and variants from traditional compilations
- Community contributions and feedback

## Contact

For questions or contributions, please open an issue in the repository.
