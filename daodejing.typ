// Load chapters by number instead of globbing
#let chapter-count = 81

// Set up document
#set document(title: "Dao De Jing")

#set page(
  paper: "a5",
  margin: (x: 1.5cm, y: 2cm),
)

// Define separate fonts for Chinese and English text
#let chinese-font = ("Kaiti TC")
#let english-font = ("Baskerville")
#let pinyin-font = ("Garamond")
#set text(font: chinese-font)

// Create a counter for chapters
#let chapter-counter = counter("chapter")

// Create a function to display a character with its calque
#let is-annotation(text) = text.contains("(") or text.contains(")") or text.contains("•") or text.contains("[") or text.contains("]") or text.contains("__") or text.contains("...")

#let fill = rgb("999")

#let format-chinese(original, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: chinese-font, size: 23pt, ..style)[#original.replace("(", "").replace(")", "").replace("[", "").replace("]", "").replace(".", "").replace("", "")]
}

#let format-calque(calque, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: english-font, size: 7pt, ..style, weight: "medium")[#calque.replace("(", "").replace(")", "").replace(".", "").replace("[", "").replace("]", "").replace("__","(blank)")]
}

#let format-pinyin(pinyin, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: pinyin-font, size: 5.6pt, ..style, weight: "medium")[#pinyin.replace("(", "").replace(")", "").replace(".", "").replace("[", "").replace("]", "").replace("__","")]
}

#let char-unit(original, calque, pinyin) = {
  let annotated = is-annotation(calque) or is-annotation(original)
  
  box[
    #stack(
      dir: ttb,
      spacing: 0.5em,
      align(center)[#format-pinyin(pinyin, annotated)],
      align(center)[#format-chinese(original, annotated)],
      align(center)[#v(0.1em)#h(0.2em)#format-calque(calque, annotated)#h(0.2em)],
    )
  ]
}

// Title
#align(center + horizon)[
  #stack(
    dir: ltr,
    spacing: 2em,
    [
      #char-unit("道", "way", "dào")
      #char-unit("德", "virtue", "dé")
      #char-unit("經", "classic", "jīng")
    ],
    text(font: english-font, size: 30pt, weight: "medium")[Dao De Jing],
  )
]

#pagebreak()

#set page(
  paper: "a5",
  margin: (x: 1.5cm, y: 2cm),
  numbering: "1",
  footer: locate(loc => {
    [
      #align(left)[#text(size: 8pt, weight: "regular")[Chapter #chapter-counter.display()]]
      #align(right)[#text(size: 8pt, weight: "regular")[#counter(page).display()]]
    ]
  })
)


// Process each chapter by number
#for chapter-num in range(1, chapter-count + 1) {
  // Step the chapter counter
  chapter-counter.step()
  
  // Format chapter number with leading zero
  let chapter-num-padded = if chapter-num < 10 {
    "0" + str(chapter-num)
  } else {
    str(chapter-num)
  }

  let chapter-path = "chapters/chapter_" + chapter-num-padded + ".xml"
  
  // Read and parse the XML file with error handling
  let chapter-data = xml(chapter-path)
  if chapter-data == none {
    panic("Failed to load chapter " + chapter-num-padded)
  }
  
  let chapter = chapter-data.first()
  
  // Display chapter number
  align(center)[
    #text(size: 18pt, weight: "bold")[Chapter #chapter-counter.display()]
    #v(1.5em)
  ]
  
  // Process each line in the chapter
  for line in chapter.children {
    if type(line) == dictionary {
      // Create a container for this line
      align(left)[
        // Display each Chinese character with its calque
        #let commentary = line.at("attrs").at("commentary", default: "")
        #if commentary != "" {
          text(
            size: 10pt, 
            weight: "light", 
            style: "italic", 
          )[#commentary]
        }

        #for word in line.children.filter(w => type(w) == dictionary) {
          let original = word.at("attrs").at("original")
          let calque = word.at("attrs").at("calque", default: "")
          let pinyin = word.at("attrs").at("pinyin", default: "")
          char-unit(original, calque, pinyin)
          h(1em)
        }
        
        #v(1.33em)
      ]
    }
  }
  
  // Add space between chapters
  pagebreak()
}