import os
import re
from langchain_aws import ChatBedrockConverse
from langchain_core.prompts import ChatPromptTemplate
from dotenv import load_dotenv

# Load environment variables from .env.local
load_dotenv('.env.local')

# Create the chapters directory if it doesn't exist
if not os.path.exists('chapters'):
    os.makedirs('chapters')

start_chapter = 54

def process_chapter_text(file_path):
    # Read the chapter text file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split the content by chapter markers and --
    chapter_blocks = re.split(r'--', content)
    
    # Initialize Bedrock client for AI processing
    llm = ChatBedrockConverse(
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
        region_name=os.getenv("AWS_REGION"),
        model_id="anthropic.claude-3-5-sonnet-20241022-v2:0",
        max_tokens=6000
    )
    
    # Sort chapters and process only chapter 37 onward
    chapters = []
    for block in chapter_blocks:
        if not block.strip():
            continue
            
        chapter_match = re.search(r'Chapter (\d+)', block)
        if chapter_match:
            chapter_num = int(chapter_match.group(1))
            if chapter_num >= start_chapter:
                chapters.append((chapter_num, block.strip()))
    
    # Sort chapters by number
    chapters.sort(key=lambda x: x[0])
    
    # Process chapters in batches of 8
    batch_size = 8
    for i in range(0, len(chapters), batch_size):
        batch = chapters[i:i+batch_size]
        batch_results = []
        
        # Process batch in parallel
        import concurrent.futures
        with concurrent.futures.ThreadPoolExecutor() as executor:
            # Submit all tasks
            future_to_chapter = {
                executor.submit(generate_xml_with_ai, llm, str(chapter_num), chapter_text): 
                (chapter_num, chapter_text) for chapter_num, chapter_text in batch if chapter_text
            }
            
            # Process results as they complete
            for future in concurrent.futures.as_completed(future_to_chapter):
                chapter_num, _ = future_to_chapter[future]
                try:
                    xml_content = future.result()
                    padded_num = str(chapter_num).zfill(2)
                    output_file = f'chapters/chapter_{padded_num}.xml'
                    
                    with open(output_file, 'w', encoding='utf-8') as f:
                        f.write(xml_content)
                        
                    print(f"Created {output_file}")
                except Exception as e:
                    print(f"Error processing chapter {chapter_num}: {e}")
prompt = ChatPromptTemplate.from_template("""
You are a Classical Chinese XML formatter specializing in the Dao De Jing (Tao Te Ching). 

NOTE: YOU must continue to output the entire requested output in one single response. DO NOT SPLIT IT INTO MORE SECTIONS.

Your task is to convert Chinese text into a structured XML format where each character is paired with its most literal English equivalent word (calque).
This is for a language learning tool where readers will learn to develop their own interpretations based on the literal word meanings in Classical Chinese,
learning to read the original text and develop an appreciation for both the wisdom, poetry, and terse nature of Classical Chinese.
This is primarily targeted to create a text for Chinese-American Heritage Carriers that can't read Chinese and want to connect with their roots.

In your chapter breakdown, include:
a) A summary of the main theme of the chapter
b) A list of key vocabulary and their potential meanings
c) Identification of grammatical structures that might be challenging
d) Notes on any historical or cultural references
e) Proposed potential areas for commentary

It's OK for this section to be quite long.

After your analysis, format the chapter according to the following guidelines:

1. Wrap the entire chapter in <chapter> tags with a "number" attribute.
2. Format each line of text within <line> tags.
3. Format each Chinese character along with its English calque within <word> tags.
4. Preserve all punctuation symbols (•), parenthetical notations [(text)], and blank spaces (__) exactly as they appear in the input.
5. Treat (.) as a single word.
6. Treat (X...) or [X...] as a single word unit where enclosed in parentheses or brackets.
7. Treat __ as a single word (...).
8. For words like "以" that have translations like "by means of", always use "by-means-of" (using hyphens instead of spaces or underscores).
9. Provide commentary on lines or words that are particularly memorable or difficult to interpret.
10. Group chinese compound words that make sense as one <word ...>. But do not add too much of a layer of translation -- it should still keep as literal as possible so they can see what type of language Classical chinese is.
1

For the commentary, imagine you are an inspiring teacher giving mini points of interest and intrigue to a reader with no knowledge of Classical Chinese. Focus on:

- Classical Chinese grammar
- Historical context
- Hints about confusing words or phrases
- Questions that prompt the reader to think deeply about the text
- How the words work together in poetry beauty

Provide hints, not translations: Commentary should illuminate possibilities without explicitly translating or interpreting the text.
Be concise and poetic: Keep commentary terse, beautiful, and thought-provoking.
Respect the reader's interpretive journey: Trust readers to form their own understanding—commentary should spark insight, not provide answers.
Focus on perspective, not direction: Open paths to meaning rather than pointing to specific interpretations.
Balance between accessibility and mystery: Provide just enough guidance to make the text accessible without removing its enigmatic quality.

Effective Commentary Approaches

Highlight language patterns: Note structural elements, parallel constructions, or recurring motifs without explaining their meaning.
Ask thought-provoking questions: Frame questions that invite deeper contemplation rather than leading to specific answers.
Identify paradoxes or tensions: Point out contrasting elements or unexpected pairings without resolving them.
Illuminate cultural context: Provide brief historical or cultural references that enrich understanding without explaining away ambiguity.
Draw attention to key characters: Note when characters have multiple meanings or special significance without definitively interpreting them.
Comment on rhythm and structure: Note poetic devices, repetition, or structural patterns that might otherwise be missed.

What to Avoid

Direct translation: Never simply restate the text in contemporary language.
Overly directive interpretation: Avoid telling readers what the text "means."
Excessive explanation: Commentary should be lighter than the text itself.
Closing off possibilities: Avoid statements that narrow rather than expand potential meanings.
Modern impositions: Resist applying contemporary frameworks that distort the text's original context.

This approach creates a commentary style that enhances rather than replaces the reader's engagement with Classical Chinese texts, providing just enough illumination to help readers navigate while preserving the joy of discovery.

Be sure to be clean, terse, and clear with your commentary. DO NOT MAKE OBVIOUS COMMENTS LIKE: "The third in the parallel set. The final line in the parallel structure." Every word counts and must deliver maximum punch -- we don't want to drown out the core text -- the highlight and focus must remain on the actual text. BE PLAYFUL, AND PHILOSOPHICAL -- ASK QUESTIONS AND ENCOURAGE THE READER TO PONDER WITH THOUGHT-PROVOKING AND THOUGHT-LEADING QUESTIONS!
 
Remember, your goal is to provide just enough information for the reader to be amazed at their own ability to piece together the right meaning. The reader should feel like they are unlocking the meaning of the text for themselves. DO NOT FLOOD THEM WITH GRAMMAR CONCEPTS! FOCUS ON THE MEANING!

The calques should be literal word-by-word translations, not interpretive translations. Focus on the most fundamental basic meaning of each character while offering guidance on interpretation (do not give direct translation) in the commentary. Ensure that each piece of commentary is guaranteed to provide the maximum clarity, odds of understanding, sense of accomplishment (they need to feel like they were able to solve a puzzle), without giving too much clear guidance. Be helpful, lean on providding perspective, not direction. THE READER SHOULD NOT FEEL LIKE IT HAS BEEN TRANSLATED FOR THEM. This is a workbook that they might use to forge their own interpretation.

Please provide your formatted XML output after your analysis.

Example of good commentary:

<line commentary="Consider how the natural properties of water—flowing downward, taking any shape, clear when undisturbed—might embody a kind of excellence we rarely value.">
    <word original="上" calque="highest" pinyin="shàng"/>
    <word original="善" calque="goodness" pinyin="shàn"/>
    <word original="若" calque="like" pinyin="ruò"/>
    <word original="水" calque="water" pinyin="shuǐ"/>
</line>

<line commentary="The key tension here lies between 'benefit' and 'not compete'—a relationship rarely celebrated in human systems that reward assertiveness.">
    <word original="水" calque="water" pinyin="shuǐ"/>
    <word original="善" calque="good-at" pinyin="shàn"/>
    <word original="利" calque="benefit" pinyin="lì"/>
    <word original="萬" calque="ten-thousand" pinyin="wàn"/>
    <word original="物" calque="things" pinyin="wù"/>
    <word original="而" calque="yet" pinyin="ér"/>
    <word original="不" calque="not" pinyin="bù"/>
    <word original="爭" calque="compete" pinyin="zhēng"/>
</line>

<line commentary="Where do we find water naturally? In the lowlands, valleys, crevices—places humans typically consider undesirable. What wisdom might this placement reveal?">
    <word original="處" calque="dwells" pinyin="chǔ"/>
    <word original="眾" calque="many" pinyin="zhòng"/>
    <word original="人" calque="people" pinyin="rén"/>
    <word original="之" calque="of" pinyin="zhī"/>
    <word original="所" calque="that-which" pinyin="suǒ"/>
    <word original="惡" calque="dislike" pinyin="wù"/>
</line>

<line commentary="Not physical blindness, but a deeper inability to perceive when overwhelmed by too much visual stimulation. What essential sights do we miss amid the dazzle?">
    <word original="五" calque="five" pinyin="wǔ"/>
    <word original="色" calque="colors" pinyin="sè"/>
    <word original="令" calque="cause" pinyin="lìng"/>
    <word original="人" calque="person" pinyin="rén"/>
    <word original="目" calque="eyes" pinyin="mù"/>
    <word original="盲" calque="blind" pinyin="máng"/>
    <word original="." calque="." pinyin="." punctuation="true"/>
</line>

<line commentary="Notice the parallel pattern continues: excessive sounds lead not to enhanced hearing but its opposite. A subtle warning about the consequences of sensory abundance.">
    <word original="五" calque="five" pinyin="wǔ"/>
    <word original="音" calque="sounds" pinyin="yīn"/>
    <word original="令" calque="cause" pinyin="lìng"/>
    <word original="人" calque="person" pinyin="rén"/>
    <word original="耳" calque="ears" pinyin="ěr"/>
    <word original="聾" calque="deaf" pinyin="lóng"/>
    <word original="." calque="." pinyin="." punctuation="true"/>
</line>

<line commentary="The character 爽 carries nuanced meanings including both 'refreshed' and 'numbed'—perhaps suggesting that overindulgence leads to diminished, not enhanced, sensory capacity.">
    <word original="五" calque="five" pinyin="wǔ"/>
    <word original="味" calque="flavors" pinyin="wèi"/>
    <word original="令" calque="cause" pinyin="lìng"/>
    <word original="人" calque="person" pinyin="rén"/>
    <word original="口" calque="mouth" pinyin="kǒu"/>
    <word original="爽" calque="numb" pinyin="shuǎng"/>
</line>

<line commentary="A paradox of releasing knowledge - what might this suggest about our attachments to learning?">
    <word original="絕" calque="cut-off" pinyin="jué"/>
    <word original="學" calque="learning" pinyin="xué"/>
    <word original="無" calque="without" pinyin="wú"/>
    <word original="憂" calque="worry" pinyin="yōu"/>
</line>

<line commentary="Listen for the echo between these sounds - harmony or dissonance?">
    <word original="唯" calque="only" pinyin="wéi"/>
    <word original="之" calque="it" pinyin="zhī"/>
    <word original="與" calque="and" pinyin="yǔ"/>
    <word original="阿" calque="slant" pinyin="ē"/>
</line>

<line commentary="A question posed without answer - the space between opposites becomes the meditation.">
    <word original="相" calque="mutual" pinyin="xiāng"/>
    <word original="去" calque="apart" pinyin="qù"/>
    <word original="幾" calque="how-many" pinyin="jǐ"/>
    <word original="何" calque="what" pinyin="hé"/>
</line>

<line commentary="Notice the parallel construction beginning to build - dualities examined side by side.">
    <word original="(美)" calque="(beautiful)" pinyin="(měi)"/>
    <word original="之" calque="it" pinyin="zhī"/>
    <word original="與" calque="and" pinyin="yǔ"/>
    <word original="惡" calque="ugly" pinyin="è"/>
</line>

<line commentary="The rhythm of inquiry continues - what does this repetition suggest about these supposed opposites?">
    <word original="相" calque="mutual" pinyin="xiāng"/>
    <word original="去" calque="apart" pinyin="qù"/>
    <word original="若" calque="like" pinyin="ruò"/>
    <word original="何" calque="what" pinyin="hé"/>
</line>

<line commentary="A double negation creates emphasis - what collective wisdom might reside in shared apprehension?">
    <word original="人" calque="person" pinyin="rén"/>
    <word original="之" calque="of" pinyin="zhī"/>
    <word original="所" calque="place" pinyin="suǒ"/>
    <word original="畏" calque="fear" pinyin="wèi"/>
    <word original="不" calque="not" pinyin="bù"/>
    <word original="可" calque="can" pinyin="kě"/>
    <word original="不" calque="not" pinyin="bù"/>
    <word original="畏" calque="fear" pinyin="wèi"/>
    <word original="." calque="." pinyin="." punctuation="true"/>
</line>

<line commentary="A sigh through the poetic particle '兮' - vastness without boundary stretches before us.">
    <word original="荒" calque="desolate" pinyin="huāng"/>
    <word original="兮" calque="ah" pinyin="xī"/>
    <word original="其" calque="its" pinyin="qí"/>
    <word original="未" calque="not-yet" pinyin="wèi"/>
    <word original="央" calque="end" pinyin="yāng"/>
    <word original="哉" calque="indeed" pinyin="zāi"/>
    <word original="(.)" calque="(.)" pinyin="(.)" punctuation="true"/>
</line>


For example, if given:
Chapter 70
吾 言 甚 易 知 •
甚 易 行 (•)

REQUIRED OUTPUT:

```xml
<chapter number="70">
<line commentary="...">
    <word original="吾" pinyin="wú" calque="I"/>
    <word original="言" pinyin="yán" calque="word"/>
    <word original="甚" pinyin="shèn" calque="very"/>
    <word original="易" pinyin="yì" calque="easy"/>
    <word original="知" pinyin="zhī" calque="know"/>
    <word original="•" pinyin="" calque="•" punctuation="true"/>
</line>
<line>
    <word original="甚" pinyin="shèn" calque="very"/>
    <word original="易" pinyin="yì" calque="easy"/>
    <word original="行" pinyin="xíng" calque="practice"/>
    <word original="(•)" pinyin="" calque="(•)" punctuation="true"/>
</line>
</chapter>
```

-------
Please process the following chapter:

{input}
""")

def generate_xml_with_ai(llm, chapter_num, chapter_text):
    response = prompt.pipe(llm).invoke({"input": chapter_text})
    result = response.content
    # Extract just the content between <chapter> and </chapter> tags
    if "<chapter" in result and "</chapter>" in result:
        start_idx = result.find("<chapter")
        end_idx = result.find("</chapter>") + len("</chapter>")
        xml_content = result[start_idx:end_idx]
    else:
        # Fallback if the expected tags aren't found
        xml_content = f'<chapter number="{chapter_num}">{result}</chapter>'
    
    return f'''<?xml version="1.0" encoding="UTF-8"?>
{xml_content}'''

if __name__ == "__main__":
    process_chapter_text("chapter-text.txt")
    print("All chapters processed successfully.") 
