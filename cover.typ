// Book cover template for a 6" x 9" paperback with 0.645" spine
// Dimensions in mm: 152.40mm x 228.60mm with 16.38mm spine
// Overall dimensions: 327.53mm x 234.95mm (12.895" x 9.250")
// Paper: Cream, 258 pages, Black & White

#import "utils.typ": *

#let spine-width = 16.38mm
#let book-width = 152.40mm
#let book-height = 228.60mm
#let cover-width = book-width * 2 + spine-width
#let cover-height = book-height
#let bleed = 3mm

// Set up the page with the full cover dimensions plus bleed
#set page(
  width: cover-width + bleed * 2,
  height: cover-height + bleed * 2,
  margin: 0pt,
)

// Main cover container with bleed area
#box(
  width: cover-width + bleed * 2,
  height: cover-height + bleed * 2,
  fill: white,
  [
    // Back cover (left side)
    #place(
      top + left,
      dx: bleed,
      dy: bleed,
      box(
        width: book-width,
        height: book-height,
        fill: white,
        stroke: (paint: black, thickness: 0.5pt, dash: "dotted"),
        [
          #pad(x: 1.5cm, y: 2cm)[
            #align(center)[
              #text(font: chinese-font, size: 35pt, weight: "bold")[道]
              #text(font: chinese-font, size: 35pt, weight: "bold")[德]
              #text(font: chinese-font, size: 35pt, weight: "bold")[經]
              #v(0.5em)
              #text(font: english-font, style: "italic", size: 14pt)[A Word-by-Word Journey Through Ancient Wisdom]
            ]
            
            #v(1.5em)
            
            #text(font: english-font, size: 12pt, weight: "regular")[
              This edition offers an unprecedented approach to experiencing the Dao De Jing—not through conventional translation, but through careful illumination of the text's original structure and meaning. Presenting Laozi's timeless classic using word-by-word calques, this volume preserves the essential nature of classical Chinese while making it accessible to English readers.
              
              #v(0.8em)
              
              Unlike conventional translations that inevitably impose interpretive decisions, this innovative edition invites you to discover the Dao De Jing as it was meant to be encountered—ambiguous, layered, and rich with potential meanings. Each line is presented with the original Chinese character, its pinyin pronunciation, and a carefully selected English calque that captures the character's most appropriate semantic field.
              
              #v(0.8em)
              
              This edition recognizes that the Dao De Jing was written not just to convey philosophy but to explore the limits of language itself. By preserving the text's inherent ambiguity and structural patterns, it offers perhaps the closest possible experience to reading the original.
              
              #v(0.8em)
              
              #emph[Embrace the journey of discovering the Dao De Jing's wisdom on your own terms. As Laozi himself might suggest, the path that can be definitively translated is not the eternal path.]
            ]
          ]
        ]
      )
    )
    
    // Spine (center)
    #place(
      top + left,
      dx: bleed + book-width,
      dy: bleed,
      box(
        width: spine-width,
        height: book-height,
        fill: white,
        stroke: (paint: black, thickness: 0.5pt, dash: "dotted"),
        [
          #align(horizon)[
            #rotate(
              90deg,
              text(font: english-font, size: 12pt, weight: "regular")[
                DAO DE JING
              ]
            )
          ]
        ]
      )
    )
    
    // Front cover (right side)
    #place(
      top + left,
      dx: bleed + book-width + spine-width,
      dy: bleed,
      box(
        width: book-width,
        height: book-height,
        fill: white,
        stroke: (paint: black, thickness: 0.5pt, dash: "dotted"),
        [
          #align(center + horizon)[
            #stack(
              spacing: 2em,
              image("pic.png", width: 80%),
              text(font: english-font, size: 14pt, style: "italic")[
                The Classic of the Way and Virtue
              ]
            )
          ]
        ]
      )
    )
    
    // Trim guides at corners (optional)
    #place(
      top + left,
      dx: bleed,
      dy: bleed,
      line(
        start: (0pt, 0pt),
        end: (5mm, 0pt),
        stroke: (paint: rgb("#999999"), thickness: 0.25pt)
      )
    )
    #place(
      top + left,
      dx: bleed,
      dy: bleed,
      line(
        start: (0pt, 0pt),
        end: (0pt, 5mm),
        stroke: (paint: rgb("#999999"), thickness: 0.25pt)
      )
    )
  ]
)
