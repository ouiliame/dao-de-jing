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
#set text(font: chinese-font)

// Create a counter for chapters
#let chapter-counter = counter("chapter")

// Title
#align(center + horizon)[
  #text(font: "Kaiti SC", size: 36pt, weight: "regular")[道 德 經]
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

// Create a function to display a character with its calque
#let is-annotation(text) = text.contains("(") or text.contains(")") or text.contains("•") or text.contains("[") or text.contains("]") or text.contains("__") or text.contains("...")

#let fill = rgb("#b3b3b3")

#let format-chinese(original, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: chinese-font, size: 20pt, ..style)[#original.replace("(.)", "")]
}

#let format-calque(calque, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: english-font, size: 7pt, ..style, weight: "medium")[#calque.replace("(.)", "").replace(".", "")]
}

#let char-unit(original, calque) = {
  let annotated = is-annotation(calque) or is-annotation(original)
  
  box[
    #stack(
      dir: ttb,
      spacing: 0.75em,
      align(center)[#format-chinese(original, annotated)],
      align(center)[#format-calque(calque, annotated)]
    )
  ]
}

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
            size: 9pt, 
            weight: "light", 
            style: "italic", 
          )[#commentary]
        }

        #for word in line.children.filter(w => type(w) == dictionary) {
          let original = word.at("attrs").at("original")
          let calque = word.at("attrs").at("calque", default: "")
          char-unit(original, calque)
          h(1em)
        }
        
        #v(2em)
      ]
    }
  }
  
  // Add space between chapters
  pagebreak()
}