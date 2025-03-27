#set page(
  paper: "a5",
  margin: (x: 1.5cm, y: 2cm),
  numbering: none,
)

#set heading(numbering: none)

#import "utils.typ": *

#set text(font: english-font, size: 10pt, weight: "light");

#let chinese(x, size: 10pt) = {
  text(font: chinese-font, size: size, weight: "light")[#x]
}

#heading(level: 1)[Preface]

Like the _Dao De Jing_ itself, what this version offers is the opportunity to let the book truly be yours. Yes, the _Dao De Jing_ seems cryptic in this presentation—but it is similarly cryptic for the Chinese scholar. This non-translated version allows you to experience the philosophy fully, as close as it was meant to be perceived.

Above most lines, you will find a short insightful question that serves as a gentle guide or hint to aid your exploration. The calques have been prepared to match the most literal sense of each word that still ties into the context, with great care to select the appropriate semantic field closest to the classical Chinese. The modern pinyin is also provided in case you want to search up a word, but note that the classical Chinese of Laozi's era was probably spoken quite differently.

We encourage you: don't rush to try and understand or translate. Sit with a few lines first, contemplate the meaning of the words and their potential interpretations. Frustration is normal. We are confident that this way of presenting is the best way to truly grok Daoism—after all, the _Dao De Jing_ was written to explore language itself too.

#heading(level: 2)[Introduction]

Classical Chinese (#chinese("文言文")) served as the literary language of China for over two millennia, remaining relatively unchanged while spoken language evolved dramatically. The text you're about to encounter is presented with word-by-word calques—literal translations that preserve the original structure while providing access to the meaning. This approach offers a window into both the content and the distinctive patterns of classical Chinese thought.

Reading classical Chinese requires a different mindset than approaching modern languages. The grammar is exceptionally economical, with single characters often carrying multiple potential functions. Context, rather than explicit markers, determines meaning. What might seem frustratingly ambiguous to the modern reader was considered elegant and profound by classical scholars—indeed, this ambiguity is often central to the philosophical insights being conveyed.

== Key Features of Classical Chinese

=== 1. Extreme Concision

Classical Chinese prized brevity. A text like the _Dao De Jing_ exemplifies this quality, with profound concepts expressed in just a few characters. What might require a paragraph in English often appears as a simple four-character phrase in classical Chinese. This concision isn't merely stylistic—it reflects a philosophical belief that excessive words obscure truth rather than reveal it.

=== 2. Fluid Part of Speech

Unlike English, where words typically function as specific parts of speech, classical Chinese words shift freely between roles. A character might serve as a noun in one context, a verb in another, and an adjective in a third. This fluidity allows for remarkable linguistic economy but requires readers to remain attentive to context.

=== 3. Implied Subjects and Objects

Classical Chinese frequently omits subjects and objects when they can be inferred from context. Modern readers often find themselves asking "who?" or "what?" when translating these passages. The answer typically lies in the broader context of the discussion.

== Essential Grammatical Words

The following function words form the backbone of classical Chinese grammar. Understanding them will significantly enhance your reading experience:

The following table presents the essential grammatical particles that will be explained in detail:

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  [*Character*], [*Pinyin*], [*Primary Functions*],
  chinese("之", size: 16pt), [_zhī_], [Possessive marker, object pronoun, nominalizer],
  chinese("者", size: 16pt), [_zhě_], [Nominalizer, topic marker],
  chinese("也", size: 16pt), [_yě_], [Assertion marker, copula],
  chinese("其", size: 16pt), [_qí_], [Possessive pronoun, hypothetical marker],
  chinese("而", size: 16pt), [_ér_], [Conjunction, adverbial marker],
  chinese("以", size: 16pt), [_yǐ_], [Instrumental marker, causative marker],
  chinese("於", size: 16pt), [_yú_], [Locative marker, comparative marker],
  chinese("故", size: 16pt), [_gù_], [Logical connector, cause marker],
  chinese("兮", size: 16pt), [_xī_], [Rhythmic pause marker],
)

Each particle will be illustrated with examples showing its usage in context, along with English equivalents to help clarify their functions in classical Chinese texts.

#v(2em)
=== #chinese("之", size: 24pt) (_zhī_)
#v(0.3em)

Perhaps the most versatile particle in classical Chinese, #chinese("之"):

#translation(
  char-units((
    ("天", "heaven", "tiān"),
    ("之", "'s", "zhī"),
    ("道", "way", "dào")
  )),
  text(size: 10pt, weight: "light")[Functions as a possessive marker (similar to _'s_ or _of_)
  #quoted("The way of Heaven")
  ]
)

#translation(
  char-units((
    ("見", "see", "jiàn"),
    ("之", "it", "zhī")
  )),
  text(size: 10pt, weight: "light")[Serves as an object pronoun (_it_, _him_, _her_, _them_)
  #quoted("See it/him/her/them")
  ]
)

#translation(
  char-units((
    ("善", "good", "shàn"),
    ("之", "of", "zhī"),
    ("為", "being", "wéi"),
    ("善", "good", "shàn")
  )),
  text(size: 10pt, weight: "light")[Creating nominalization (turning verbs or phrases into nouns)
  #quoted("The goodness of goodness")
  ]
)

#translation(
  char-units((
    ("往", "go", "wǎng"),
    ("之", "toward", "zhī")
  )),
  text(size: 10pt, weight: "light")[Acts as a directional particle indicating movement
  #quoted("Go toward it")
  ]
)

When you encounter #chinese("之"), ask yourself if it's connecting a possessor and possessed, replacing an object, creating a noun phrase, or indicating direction.

#v(2em)
=== #chinese("其", size: 24pt) (_qí_)
#v(0.3em)

This character typically:

#translation(
  char-units((
    ("其", "its/their", "qí"),
    ("母", "mother", "mǔ")
  )),
  text(size: 10pt, weight: "light")[Works as a possessive pronoun ("his," "her," "its," "their")
  #quoted("its mother")
  ]
)

#translation(
  char-units((
    ("其", "that", "qí"),
    ("人", "person", "rén")
  )),
  text(size: 10pt, weight: "light")[Functions as a demonstrative ("that")

  #quoted("that person")
  ]
)

#translation(
  char-units((
    ("其", "it", "qí"),
    ("死", "die", "sǐ"),
    ("乎", "?", "hū")
  )),
  text(size: 10pt, weight: "light")[Introduces a projected or hypothetical situation
  #quoted("Will it die?")
  ]
)

The context often determines whether #chinese("其") indicates possession or serves a demonstrative function.

#v(2em)
=== #chinese("也", size: 24pt) (_yě_)
#v(0.3em)

This final particle:

#translation(
  char-units((
    ("也", "indeed", "yě"),
    ("道", "way", "dào")
  )),
  text(size: 10pt, weight: "light")[Marks declarative statements (similar to a period or "indeed").

  #quoted("It is the Way.")
  ]
)

#translation(
  char-units((
    ("也", "indeed", "yě"),
    ("善", "good", "shàn")
  )),
  text(size: 10pt, weight: "light")[Creates emphasis or assertion.

  #quoted("It is indeed good.")
  ]
)

#v(2em)
=== #chinese("者", size: 24pt) (_zhě_)
#v(0.3em)

This nominalizer:

#translation(
  char-units((
    ("為", "do", "wéi"),
    ("學", "study", "xué"),
    ("者", "one who", "zhě")
  )),
  text(size: 10pt, weight: "light")[Transforms verbs or phrases into nouns (like "-er" or "one who").

  #quoted("one who studies")
  ]
)

#translation(
  char-units((
    ("善", "good", "shàn"),
    ("者", "that which is", "zhě")
  )),
  text(size: 10pt, weight: "light")[Creates abstract concepts.

  #quoted("goodness")
  ]
)

#translation(
  char-units((
    ("道", "way", "dào"),
    ("者", "topic marker", "zhě"),
    ("萬", "ten thousand", "wàn"),
    ("物", "things", "wù"),
    ("之", "of", "zhī"),
    ("奧", "mystery", "ào")
  )),
  text(size: 10pt, weight: "light")[Marks the topic in a topic-comment structure.

  #quoted("The Way is the mystery of all things.")
  ]
)

#v(2em)
=== #chinese("而", size: 24pt) (_ér_)
#v(0.3em)

This conjunctive particle:

#translation(
  char-units((
    ("為", "act", "wéi"),
    ("而", "and yet", "ér"),
    ("不", "not", "bù"),
    ("恃", "rely on", "shì")
  )),
  text(size: 10pt, weight: "light")[Connects related clauses (_and_, _but_, _yet_, _while_).

  #quoted("act and yet do not rely on")
  ]
)

#translation(
  char-units((
    ("生", "give life", "shēng"),
    ("而", "and then", "ér"),
    ("不", "not", "bù"),
    ("有", "possess", "yǒu")
  )),
  text(size: 10pt, weight: "light")[Indicates sequence (_and then_).

  #quoted("give life and then do not possess")
  ]
)

#translation(
  char-units((
    ("大", "great", "dà"),
    ("直", "straightness", "zhí"),
    ("若", "seems", "ruò"),
    ("屈", "bent", "qū")
  )),
  text(size: 10pt, weight: "light")[Shows contrast (_but_, _yet_).

  #quoted("great straightness seems bent")
  ]
)

#v(2em)
=== #chinese("以", size: 24pt) (_yǐ_)
#v(0.3em)

This versatile word marks instrumental use (_by_, _with_, _using_):

#translation(
  char-units((
    ("以", "using", "yǐ"),
    ("身", "oneself", "shēn"),
    ("觀", "observe", "guān"),
    ("其", "it", "qí"),
    ("妙", "wonder", "miào")
  )),
  text(size: 10pt, weight: "light")[Shows purpose (_in order to_).

  #quoted("in order to observe its wonder")
  ]
)

#translation(
  char-units((
    ("以", "because", "yǐ"),
    ("其", "it", "qí"),
    ("無", "without", "wú"),
    ("私", "self", "sī")
  )),
  text(size: 10pt, weight: "light")[Indicates causation (_because_).

  #quoted("because of its selflessness")
  ]
)

#v(2em)
=== #chinese("於", size: 24pt) (_yú_)
#v(0.3em)

This preposition indicates

#translation(
  char-units((
    ("處", "dwell", "chǔ"),
    ("於", "at", "yú"),
    ("上", "high", "shàng")
  )),
  text(size: 10pt, weight: "light")[Location ("at," "in"):
  
  #quoted("dwells in the high place")
  ]
)

#translation(
  char-units((
    ("大", "greater", "dà"),
    ("於", "than", "yú"),
    ("其", "its", "qí"),
    ("細", "small parts", "xì")
  )),
  text(size: 10pt, weight: "light")[Comparison ("than"):
  
  #quoted("greater than its small parts")
  ]
)

#translation(
  char-units((
    ("歸", "returns", "guī"),
    ("於", "to", "yú"),
    ("無", "no", "wú"),
    ("物", "thing", "wù")
  )),
  text(size: 10pt, weight: "light")[Direction ("to," "toward"):
  #quoted("returns to nothingness")
  ]
)

#v(2em)
=== #chinese("故", size: 24pt) (_gù_)
#v(0.3em)

This logical connector:

#translation(
  char-units((
    ("故", "therefore", "gù"),
    ("能", "can", "néng"),
    ("長", "long", "cháng"),
    ("生", "live", "shēng")
  )),
  text(size: 10pt, weight: "light")[Shows causation ("therefore," "thus"):
  
  #quoted("therefore can live long")
  ]
)

#translation(
  char-units((
    ("故", "therefore", "gù"),
    ("去", "reject", "qù"),
    ("彼", "that", "bǐ"),
    ("取", "take", "qǔ"),
    ("此", "this", "cǐ")
  )),
  text(size: 10pt, weight: "light")[Introduces explanation ("because," "for"):
  
  #quoted("therefore reject that and take this")
  ]
)

#v(2em)
=== #chinese("兮", size: 24pt) (_xī_)
#v(0.3em)

This particle:

#translation(
  char-units((
    ("湛", "profound", "zhàn"),
    ("兮", "(exclamation)", "xī")
  )),
  text(size: 10pt, weight: "light")[Marks rhythmic pause in poetic texts, like "ah!"

  #quoted("profound, ah!")
  ]
)

#pagebreak()
== Reading Strategies

=== 1. Look for Parallelism

Classical Chinese texts, especially philosophical works, frequently use parallel structures where successive phrases follow identical grammatical patterns. Identifying these patterns helps clarify meaning:

#char-units((
  ("天", "heaven", "tiān"),
  ("長", "long", "cháng"),
  ("地", "earth", "dì"),
  ("久", "enduring", "jiǔ")
))
#text(size: 10pt, weight: "light")[
  #quoted("Heaven is long, Earth is enduring")
]

#char-units((
  ("天", "heaven", "tiān"),
  ("地", "earth", "dì"),
  ("所", "that which", "suǒ"),
  ("以", "by means of", "yǐ"),
  ("能", "can", "néng"),
  ("長", "long", "cháng"),
  ("且", "and", "qiě"),
  ("久", "enduring", "jiǔ"),
  ("者", "(nominalizer)", "zhě")
))
#text(size: 10pt, weight: "light")[
  #quoted("The reason heaven and earth can be long and enduring")
]

#char-units((
  ("以", "because", "yǐ"),
  ("其", "they", "qí"),
  ("不", "not", "bù"),
  ("自", "self", "zì"),
  ("生", "live", "shēng")
))
#text(size: 10pt, weight: "light")[
  #quoted("is because they do not live for themselves")
]

Here, the parallelism reveals the philosophical point through structural repetition.

=== 2. Recognize Common Patterns

Certain grammatical patterns appear frequently:

- X 之 Y: Typically "Y of X" or "X's Y"
- X 者 Y 也: "X is Y" or "As for X, it is Y"
- 非 X 也: "It is not X"
- X 而 Y: "X and Y" or "X but Y"
- 以 X 為 Y: "Take X as Y" or "Use X for Y"

=== 3. Pay Attention to Pronouns

Classical Chinese pronouns are context-dependent. The same character might refer to different entities within a single passage. When you encounter pronouns like 其, 之, or 吾, ask yourself what they're referencing.

=== 4. Understand Implicit Logic

Classical Chinese often omits logical connectors that would be required in English. Statements may appear side by side without explicit indication of their relationship. Look for implied causation, contrast, or sequence.

=== 5. Embrace Ambiguity

Many classical texts, particularly Daoist works like the one you're about to read, intentionally employ ambiguity as a philosophical tool. Multiple valid interpretations may exist simultaneously—this isn't a failure of the text but often its intended effect.

== About This Edition's Calques

The calque format used in this edition presents each Chinese character with its pronunciation and a direct English equivalent, preserving the original structure while making the text accessible:


These calques represent an intermediate step between the original text and a fluid translation. They reveal the grammatical structure while the commentaries provide context and interpretive guidance.

As you read, allow the original pattern of thought to emerge through this format. The seemingly strange word order and unexpected connections are not deficiencies but rather windows into a different way of conceptualizing reality. By meeting the text on its own terms, you'll discover not just what it says, but how classical Chinese thought itself was structured.

This approach invites you to participate in the interpretive process rather than receiving a finished translation. In this way, you'll experience something closer to how these texts have been read throughout Chinese history—as living documents that reveal different facets of meaning with each encounter.

#v(2em)
== A Final Invitation

As you prepare to engage with the _Dao De Jing_, remember this timeless wisdom from the text:

#char-units((
  ("千", "thousand", "qiān"),
  ("里", "li", "lǐ"),
  ("之", "'s", "zhī"),
  ("行", "journey", "xíng"),
  ("始", "begins", "shǐ"),
  ("於", "with", "yú"),
  ("足", "foot", "zú"),
  ("下", "beneath", "xià")
))
#text(size: 10pt, weight: "light")[A reminder that even the greatest endeavors start with a single step.
#quoted("A journey of a thousand li begins beneath one's feet!")]

Don't be intimidated by the vastness of this ancient text. Like any journey, your exploration begins with a single step. Take it one character at a time, and before you know it, you'll have traveled far in your understanding.

Enjoy the journey!


