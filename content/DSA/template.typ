#import "@preview/indenta:0.0.3":*
#import emoji: lightbulb

// TODO: 1. Make sure no page breaks between the blocks and their titles
#let font = (
  main: "IBM Plex Sans",
  mono: "IBM Plex Mono",
  cjk: "Noto Sans SC",
  emph: "Kaiti",
  quote: ("IBM Plex Serif", "Noto Serif SC"),
  cjkmono: "LXGW WenKai Mono GB",
)

#let principle_class(body) = {
  grid(columns: (1em, body.len() / 3 * 1em, 1fr), column-gutter: 8pt)[
    #v(4pt) #line(length: 100%, stroke: 0.7pt)
  ][
    *#body*
  ][
    #v(4pt) #line(length: 100%, stroke: 0.7pt)
  ]
}

/* Blocks */
// Pls add or remove elements in this array first,
// if you want to add or remove the class of blocks
#let classes = ("Definition", "Lemma", "Theorem", "Corollary", "Principle")
#let h1_marker = counter("h1")
#let h2_marker = counter("h2")

#let rel(str) = {
  h(1fr)
  // link(label(str))[
  //   #lightbulb
  //   #str
  // ]
  str
}

#let note_block(body, class: "Block", fill: rgb("#FFFFFF"), stroke: rgb("#000000")) = {
  let block_counter = counter(class)

  locate(loc => {
    // Returns the serial number of the current block
    // The format is just like "Definition 1.3.1"
    let serial_num = (h1_marker.at(loc).last(), h2_marker.at(loc).last(), block_counter.at(loc).last() + 1)
    .map(str)
    .join(".")

    let serial_label = label(class + " " + serial_num)

    v(2pt + 6pt)
    text(12pt, weight: "bold")[#serial_label]
    // serial_num
    block_counter.step()
    v(-8pt)

    block(fill: fill, width: 100%, inset: 8pt, radius: 4pt, stroke: stroke, body)
  })
}

// You can change the class name or color here
#let definition(body) = note_block(body, class: "定义", fill: rgb("#EDF1D6"), stroke: rgb("#609966"))

#let theorem(body) = note_block(body, class: "定理", fill: rgb("#FEF2F4"), stroke: rgb("#EE6983"))

#let lemma(body) = note_block(body, class: "引理", fill: rgb("#FFF4E0"), stroke: rgb("#F4B183"))

#let corollary(body) = note_block(body, class: "推论", fill: rgb("#F7FBFC"), stroke: rgb("#769FCD"))

#let principle_block(name, body, class: "原理", fill: rgb("#fafffb"), stroke: rgb("#76d195")) = {
  let block_counter = counter(class)

  locate(loc => {
    // Returns the serial number of the current block
    // The format is just like "Definition 1.3.1"
    let serial_num = str(block_counter.at(loc).last() + 1)

    let serial_label = label(name)

    v(2pt)
    text(12pt, weight: "bold")[#class #serial_num #serial_label #block_counter.step()]
    text(12pt, weight: "black")[#name]
    v(-8pt)

    block(fill: fill, width: 100%, inset: 8pt, radius: 4pt, stroke: stroke, body)
  })
}

#let principle(name, body) = principle_block(name, body, class: "原理")

/* Figures */
// The numbering policy is as before, and the default display is centered
#let notefig(path, width: 100%) = {
  let figure_counter = counter("Figure")

  locate(loc => {
    let serial_num = (h1_marker.at(loc).last(), h2_marker.at(loc).last(), figure_counter.at(loc).last() + 1)
    .map(str)
    .join(".")

    let serial_label = label("Figure" + " " + serial_num)

    block(width: 100%, inset: 8pt, align(center)[#image(path, width: width)])

    set align(center)
    text(12pt, weight: "bold")[图 #serial_num #serial_label #figure_counter.step()]
  })
}

/* Proofs */
#let proof(body) = {
  [*#smallcaps("Proof"):*]

  [#body]

  align(right)[*End of Proof*]
}

/* References of blocks */
// Automatically jump to the corresponding blocks
// The form of the input should look something like "Definition 1.3.1"
#let refto(class_with_serial_num, alias: none) = {
  if alias == none {
    link(label(class_with_serial_num), [*#class_with_serial_num*])
  } else {
    link(label(class_with_serial_num), [*#alias*])
  }
}

/* Headings of various levels */
// Templates support up to three levels of headings,
// and notes with more than three headings are usually mess :)
#let set_headings(body) = {
  set heading(numbering: "1.1.1")

  // 1st level heading
  show heading.where(level: 1): it => [
    // Under each new h1, reset the sequence number of the blocks
    #for class in classes {
      counter(class).update(0)
    }
    #counter("h2").update(0)
    #counter("Figure").update(0)

    // Start a new page unless this is the first chapter
    #locate(loc => {
      let h1_before = query(heading.where(level: 1).before(loc), loc)

      if h1_before.len() != 1 {
        pagebreak()
      }
    })

    // Font size and white space
    #set text(20pt, weight: "bold")
    #block[Chapter #counter(heading).display(): #it.body]
    #v(25pt)
    #h1_marker.step()
  ]

  // 2st level heading
  show heading.where(level: 2): it => [
    #set text(17pt, weight: "bold")
    #block[#it]
    #h2_marker.step()
  ]

  // 3st level heading
  show heading.where(level: 3): it => [
    #set text(14pt, weight: "bold")
    #block[#it]
  ]

  body
}

/* Cover page */
// Create a note cover with the course name, author, and time
// Modify parameters here if you want to add or modify information item
#let cover_page(title, author, professor, creater, time, abstract) = {
  set page(paper: "a4", header: align(right)[
    #smallcaps[#title]
    #v(-6pt)
    #line(length: 40%)
  ], footer: locate(loc => {
    align(center)[#loc.page()]
  }))

  block(height: 25%, fill: none)
  align(center, text(18pt)[*Lecture Notes: #title*])
  align(center, text(12pt)[*By #author*])
  align(center, text(11pt)[_Taught by Prof. #professor _])

  v(7.5%)
  abstract

  block(height: 35%, fill: none)
  align(center, [*#creater, #time*])
}

/* Outline page */
// Defualt depth is 2
#let outline_page(title) = {
  set page(
    paper: "a4",
    // Headers are set to right- and left-justified
    // on odd and even pages, respectively
    header: locate(loc => {
      if calc.odd(loc.page()) {
        align(right)[
          #smallcaps[#title]
          #v(-6pt)
          #line(length: 40%)
        ]
      } else {
        align(left)[
          #smallcaps[#title]
          #v(-6pt)
          #line(length: 40%)
        ]
      }
    }),
    footer: locate(loc => {
      align(center)[#loc.page()]
    }),
  )

  show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    strong(it)
  }

  align(center, text(18pt, weight: "bold")[#title])
  v(15pt)
  outline(title: none, depth: 2, indent: auto)
}

/* Body text page */
// Format the headers and headings of the body
#let body_page(title, body) = {
  set page(paper: "a4", header: locate(loc => {
    let h1_before = query(heading.where(level: 1).before(loc), loc)

    let h1_after = query(heading.where(level: 1).after(loc), loc)

    // Right- and left-justified on odd and even pages, respectively
    // Automatically matches the nearest level 1 title
    if calc.odd(loc.page()) {
      if h1_before == () {
        align(right)[_ #h1_after.first().body _ #v(-6pt) #line(length: 40%)]
      } else {
        align(right)[_ #h1_before.last().body _ #v(-6pt) #line(length: 40%)]
      }
    } else {
      if h1_before == () {
        align(left)[_ #h1_after.first().body _ #v(-6pt) #line(length: 40%)]
      } else {
        align(left)[_ #h1_before.last().body _ #v(-6pt) #line(length: 40%)]
      }
    }
  }), footer: locate(loc => {
    align(center)[#loc.page()]
  }))

  set_headings(body)
}

/* All pages */
// Organize all types of pages
// If you want to add or modify other global Settings, please do so here
#let note_page(title, author, professor, creater, time, abstract, body) = {
  set text(font: (font.main, font.cjk), lang: "zh", region: "cn", weight: "light")
  set document(title: title, author: author)
  set par(justify: true)
  show math.equation.where(block: true) :it=>block(width: 100%, align(center, it))

  show raw: set text(font: (font.mono, font.cjkmono))
  show emph: set text(font: (font.main, font.emph))
  show quote: set text(font: (font.quote))
  show quote.where(block: true): it => [
    #v(-4pt)
    #block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%)[
      #it.body
      #if (it.attribution != none) [
        #v(-1em)
        #align(right)[-- #it.attribution]
      ]
    ]
  ]

  show link: underline
  set list(indent: 6pt)
  set enum(indent: 6pt)

  // Display inline code in a small box
  // that retains the correct baseline.
  show raw.where(block: false): box.with(fill: luma(240), inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 2pt)

  let cjk-markers = regex("[“”‘’．，。、？！：；（）｛｝［］〔〕〖〗《》〈〉「」【】『』─—＿·…\u{30FC}]+")
  show cjk-markers: set text(font: font.cjk)
  show raw: it => {
    show cjk-markers: set text(font: font.cjk)
    it
  }

  // Display block code in a larger block
  // with more padding.
  // and with line numbers.
  // Thank you @Andrew15-5 for the idea and the code!
  // https://github.com/typst/typst/issues/344#issuecomment-2041231063
  let style-number(number) = text(gray)[#number]
  show raw.where(block: true): it => block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )[#grid(columns: (1em, 1fr), align: (right, left), column-gutter: 0.7em, row-gutter: 0.6em, ..it.lines
    .enumerate()
    .map(((i, line)) => (style-number(i + 1), line))
    .flatten())]

  cover_page(title, author, professor, creater, time, abstract)

  outline_page("目录")

  body_page(title, body)
}