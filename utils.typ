// Define separate fonts for Chinese and English text
#let chinese-font = ("Kaiti TC")
#let english-font = ("Baskerville")
#let pinyin-font = ("Garamond")

// Create a counter for chapters
#let chapter-counter = counter("chapter")

// Helper function to detect annotations
#let is-annotation(text) = text.contains("(") or text.contains(")") or text.contains("•") or text.contains("[") or text.contains("]") or text.contains("__") or text.contains("...")

// Define a consistent fill color for annotations
#let fill = rgb("999")

// Format Chinese text with appropriate styling
#let format-chinese(original, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: chinese-font, size: 23pt, ..style)[#original.replace("(", "").replace(")", "").replace("[", "").replace("]", "").replace(".", "").replace("", "")]
}

// Format calque (translation) text with appropriate styling
#let format-calque(calque, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: english-font, size: 7pt, ..style, weight: "medium")[#calque.replace("(", "").replace(")", "").replace(".", "").replace("[", "").replace("]", "").replace("__","(blank)")]
}

// Format pinyin text with appropriate styling
#let format-pinyin(pinyin, is-annotation) = {
  let style = if is-annotation { (fill: fill) } else { (:) }
  text(font: pinyin-font, size: 5.6pt, ..style, weight: "medium")[#pinyin.replace("(", "").replace(")", "").replace(".", "").replace("[", "").replace("]", "").replace("__","")]
}

// Create a character unit with stacked elements (pinyin, character, calque)
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

#let char-units(tuples) = {
  // Takes a list of tuples and creates a row of character units
  // Each tuple should be (original, calque, pinyin)
  // original: Chinese character
  // calque: English translation
  // pinyin: Pronunciation guide
  
  let units = ()
  for (original, calque, pinyin) in tuples {
    units.push(char-unit(original, calque, pinyin))
    units.push(h(1em))
  }
  
  // Remove the last spacing if we added any units
  if units.len() > 0 {
    units.pop()
  }
  
  stack(dir: ltr, spacing: 0em, ..units)
}

#let translation(char-units-left, translation-right) = {
  // Creates a block with character units on the left and translation on the right
  block(
    breakable: false,
    grid(
      columns: (auto, 1fr),
      gutter: 2em,
      align(center + horizon)[#char-units-left],
      align(left + horizon)[#translation-right]
    )
  )
}

#let quoted(x) = {
  box(
    stroke: (paint: rgb(80%, 80%, 80%), thickness: 0.5pt),
    radius: 3pt,
    inset: (x: 8pt, y: 6pt),
    fill: rgb(98%, 98%, 98%),
    width: auto,
    text(
      font: "Garamond",
      size: 10pt, 
      weight: "regular", 
    )[#x]
  )
}