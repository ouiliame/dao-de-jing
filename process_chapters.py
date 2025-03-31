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

start_chapter = 1

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
e) Proposed potential areas for translation considerations

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
9. Provide translation on lines in the "commentary" attribute.
10. Group chinese compound words that make sense as one <word ...>. But do not add too much of a layer of translation -- it should still keep as literal as possible so they can see what type of language Classical chinese is.

For the translation (in the commentary attribute), focus on:

- Accuracy to the original text
- Capturing the philosophical depth of the Dao De Jing
- Maintaining the poetic beauty where possible
- Balancing literal meaning with contextual understanding
- Preserving the wisdom and insight of the original text

The translation should:

- Be clear and accessible to modern readers
- Maintain the philosophical nuance of the original
- Avoid overly technical language while still being precise
- Capture both literal meaning and implied significance
- Honor the poetic rhythm and flow where possible
- Reflect the terseness and ambiguity that is characteristic of Classical Chinese

The calques should be literal word-by-word translations, not interpretive translations. Focus on the most fundamental basic meaning of each character. The commentary attribute should provide a fluent, accessible English rendering of each line that captures both the literal meaning and the deeper philosophical implications.

Please provide your formatted XML output after your analysis.

Example of good translation format (using the commentary attribute for translation):

<line commentary="The highest excellence is like water.">
    <word original="上" calque="highest" pinyin="shàng"/>
    <word original="善" calque="goodness" pinyin="shàn"/>
    <word original="若" calque="like" pinyin="ruò"/>
    <word original="水" calque="water" pinyin="shuǐ"/>
</line>

<line commentary="Water benefits all things without striving.">
    <word original="水" calque="water" pinyin="shuǐ"/>
    <word original="善" calque="good-at" pinyin="shàn"/>
    <word original="利" calque="benefit" pinyin="lì"/>
    <word original="萬" calque="ten-thousand" pinyin="wàn"/>
    <word original="物" calque="things" pinyin="wù"/>
    <word original="而" calque="yet" pinyin="ér"/>
    <word original="不" calque="not" pinyin="bù"/>
    <word original="爭" calque="compete" pinyin="zhēng"/>
</line>

<line commentary="It dwells in places that people despise.">
    <word original="處" calque="dwells" pinyin="chǔ"/>
    <word original="眾" calque="many" pinyin="zhòng"/>
    <word original="人" calque="people" pinyin="rén"/>
    <word original="之" calque="of" pinyin="zhī"/>
    <word original="所" calque="that-which" pinyin="suǒ"/>
    <word original="惡" calque="dislike" pinyin="wù"/>
</line>

For example, if given:
Chapter 70
吾 言 甚 易 知 •
甚 易 行 (•)

REQUIRED OUTPUT:

```xml
<chapter number="70">
<line commentary="My words are very easy to understand.">
    <word original="吾" pinyin="wú" calque="I"/>
    <word original="言" pinyin="yán" calque="word"/>
    <word original="甚" pinyin="shèn" calque="very"/>
    <word original="易" pinyin="yì" calque="easy"/>
    <word original="知" pinyin="zhī" calque="know"/>
    <word original="•" pinyin="" calque="•" punctuation="true"/>
</line>
<line commentary="Very easy to practice.">
    <word original="甚" pinyin="shèn" calque="very"/>
    <word original="易" pinyin="yì" calque="easy"/>
    <word original="行" pinyin="xíng" calque="practice"/>
    <word original="(•)" pinyin="" calque="(•)" punctuation="true"/>
</line>
</chapter>

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
