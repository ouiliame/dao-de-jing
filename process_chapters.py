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
        model_id="anthropic.claude-3-5-sonnet-20241022-v2:0"
    )
    
    current_chapter = None
    
    for block in chapter_blocks:
        # Skip empty blocks
        if not block.strip():
            continue
            
        # Check if this block contains a chapter header
        chapter_match = re.search(r'Chapter (\d+)', block)
        if chapter_match:
            current_chapter = chapter_match.group(1)
            chapter_text = block.strip()
            
            # Skip any empty chapters
            if not chapter_text:
                continue
                
            # Create the complete XML content using AI
            padded_num = current_chapter.zfill(2)
            
            # Write to file
            output_file = f'chapters/chapter_{padded_num}.xml'
            
            # Use AI to generate the XML
            xml_content = generate_xml_with_ai(llm, current_chapter, chapter_text)
            
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(xml_content)
                
            print(f"Created {output_file}")

prompt = ChatPromptTemplate.from_template("""
You are a Classical Chinese XML formatter specializing in the Dao De Jing (Tao Te Ching). 


Your task is to convert Chinese text into a structured XML format where each character is paired with its most literal English equivalent word (calque).
This is for a language learning tool where readers will learn to develop their own interpretations based on the literal word meanings in Classical Chinese,
learning to read the original text and develop an appreciation for both the wisdom, poetry, and terse nature of Classical Chinese.
This is primarily targeted to create a text for Chinese-American Heritage Carriers that can't read Chinese and want to connect with their roots.

When given a chapter from the Dao De Jing, you will:

1. Format each line of text within <line> tags
2. Format each Chinese character along with its English calque within <word> tags
3. Wrap everything in the proper <chapter> structure
4. Preserve all punctuation symbols (•), parenthetical notations [(text)], and blank spaces (__) exactly as they appear in the input
5. Treat (.) as a single word
6. Treat (X...) or [X...] as single word unit where enclosed in parentheses or brackets
7. Treat __ as a single word (...).
8. For words like: "以" that have translations like "by means of" -- always use "by-means-of" (using hyphens instead of spaces or _)
9. There may be a line that is particularly memorable or difficult to interpret -- you should feel free to provide hints or commentary on lines or words.

For the commentary, imagine you are inspiring teacher giving mini points of interest and intrigue to a reader with no knowledge of Classical Chinese, noting interesting points to take from it.
You should be eager to provide lots of commentary and insights -- focused on NOT PROVIDING the interpretation BUT providing HELPFUL INFORMATION AND CLUES -- on Classical Chinese grammar, on historical context, etc.
It could be plain narration, or it could be a question, or it could be providing hints about the confusing vocabulary. The goal is -- provide just enough information for the reader to be amazed at their own ability to piece together the right meaning.
THE READER MUST FEEL LIKE THEY ARE UNLOCKING THE MEANING OF THE TEXT FOR THEMSELVES.

The calques should be literal word-by-word translations, not interpretive translations. Focus on the most fundamental basic meaning of each character while offering guidance on interpretation (do not give direct translation) in the commentary.

For example, if given:
Chapter 70
吾 言 甚 易 知 •
甚 易 行 (•)

You should output:```xml
<chapter number="70">
<line commentary="...">
    <word original="吾" calque="I" commentary="..."/>
    <word original="言" calque="word"/>
    <word original="甚" calque="very"/>
    <word original="易" calque="easy"/>
    <word original="知" calque="know"/>
    <word original="•" calque="•" punctuation="true"/>
</line>
<line>
    <word original="甚" calque="very"/>
    <word original="易" calque="easy"/>
    <word original="行" calque="practice"/>
    <word original="(•)" calque="(•)" punctuation="true"/>
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
