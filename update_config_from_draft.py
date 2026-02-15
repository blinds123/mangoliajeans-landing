import json
import re

def load_json(filepath):
    with open(filepath, 'r') as f:
        return json.load(f)

def save_file(filepath, content):
    with open(filepath, 'w') as f:
        f.write(content)

def read_file(filepath):
    with open(filepath, 'r') as f:
        return f.read()

def clean(text):
    """Escapes text for bash variables."""
    if not text: return ""
    return text.replace('"', '\\"').replace('\n', '<br>')

def format_fibs(fibs_data):
    """
    Formats a FIBS dictionary into a single HTML paragraph string.
    Structure:
    <strong>Fear:</strong> {fear} <strong>Intrigue:</strong> {intrigue} ...
    """
    if not fibs_data: return ""
    
    # We want a flowing paragraph, but distinctly marked sections
    # Or just a clean narrative. The prompt asked for specific bolding?
    # "FIBS STRUCTURE (DO NOT MERGE STEPS)" -> Implies distinct parts.
    
    parts = []
    if fibs_data.get('fear'):
        parts.append(f"<strong>PROBLEM:</strong> {fibs_data['fear']}")
    if fibs_data.get('intrigue'):
        parts.append(f"<strong>SECRET:</strong> {fibs_data['intrigue']}")
    if fibs_data.get('believability'):
        parts.append(f"<strong>PROOF:</strong> {fibs_data['believability']}")
    if fibs_data.get('stakes'):
        parts.append(f"<strong>RESULT:</strong> {fibs_data['stakes']}")
        
    return " ".join(parts)

def main():
    try:
        draft = load_json('copy_draft.json')
    except FileNotFoundError:
        print("❌ copy_draft.json not found.")
        return

    config_content = read_file('product.config')
    replacements = {}

    # ==========================================
    # 1. ENGAGE HOOK (Hero Section)
    # ==========================================
    if 'engage' in draft:
        # Exploit -> H1 Headline
        replacements['HEADLINE_HOOK'] = clean(draft['engage'].get('headline', ''))
        
        # Give/Narrate -> Subheadline / Tagline
        replacements['TAGLINE'] = clean(draft['engage'].get('subheadline', ''))
        
        # Opening Copy (Narrate -> Embed) -> New Hero Body Variable
        replacements['HEADLINE_OPENING_COPY'] = clean(draft['engage'].get('opening_copy', ''))

    # ==========================================
    # 2. FIBS FEATURES (Standard & Multirow)
    # ==========================================
    # The template uses "FEATURE_X" variables for the main 3 features
    # And "MULTIROW_X" variables for the checkerboard layout
    
    if 'features' in draft:
        for i, feature in enumerate(draft['features']):
            num = i + 1
            
            # Extract standard title
            title = clean(feature.get('title', ''))
            
            # format FIBS block
            fibs_text = format_fibs(feature.get('fibs', {}))
            cleaned_fibs = clean(fibs_text)
            
            # --- MAP TO STANDARD FEATURES (Top 3) ---
            # Used in sections/05-main-product.html
            replacements[f'FEATURE_HEADLINE_{num}'] = title
            replacements[f'FEATURE_HEADING_{num}'] = "" # Clear subhead as we pack it all in body
            
            # Pack full FIBS into the paragraph slots
            # Pack full FIBS into the paragraph slots
            if num == 1:
                # Feature 1 splits across two params in config usually
                # We'll just put it all in P1 and clear P2
                replacements['FEATURE_PARAGRAPH_1_1'] = cleaned_fibs
                replacements['FEATURE_PARAGRAPH_1_2'] = "" 
            else:
                replacements[f'FEATURE_PARAGRAPH_{num}'] = cleaned_fibs
                
            # --- MAP TO HERO FEATURES (Titles Only) ---
            # Used in the 4-icon grid near Buy Button
            if num <= 4:
                replacements[f'HERO_FEATURE_{num}'] = title

            # --- MAP TO MULTIROW FEATURES (Bottom 4) ---
            # Used in sections/08-multirow.html
            # These variables are MULTIROW_X_PARAGRAPH
            
            replacements[f'FEATURE_HEADLINE_{num}'] = title
            replacements[f'MULTIROW_{num}_PARAGRAPH'] = cleaned_fibs

    # ==========================================
    # 3. SECRETS (Legacy compatibility)
    # ==========================================
    if 'secrets' in draft:
        for i, secret in enumerate(draft['secrets']):
            num = i + 1
            title = clean(secret.get('title', ''))
            
            # Map Title to both Caption and Heading to ensure fullness
            replacements[f'SECRET_{num}_HEADLINE'] = title 
            replacements[f'SECRET_{num}_HEADING'] = title 
            
            # New specific keys from engage-fibs-writer
            replacements[f'SECRET_{num}_FALSE_BELIEF'] = clean(secret.get('false_belief', ''))
            
            # Map Truth Body to the paragraph(s)
            truth = clean(secret.get('truth_body', ''))
            replacements[f'SECRET_{num}_TRUTH'] = truth
            # Some templates use PARAGRAPH_X and PARAGRAPH_X_2
            replacements[f'SECRET_PARAGRAPH_{num}'] = truth
            replacements[f'SECRET_PARAGRAPH_{num}_2'] = "" # Clear second paragraph to avoid placeholder

    # ==========================================
    # 4. FOUNDER STORY (6-Part Epiphany Bridge)
    # ==========================================
    if 'founder_story' in draft:
        fs = draft['founder_story']
        replacements['FOUNDER_SECTION_HEADING'] = clean(fs.get('headline', ''))
        replacements['FOUNDER_BACKSTORY'] = clean(fs.get('backstory', ''))
        replacements['FOUNDER_WALL'] = clean(fs.get('wall', ''))
        replacements['FOUNDER_EPIPHANY'] = clean(fs.get('epiphany', ''))
        replacements['FOUNDER_PLAN'] = clean(fs.get('plan', ''))
        replacements['FOUNDER_TRANSFORMATION'] = clean(fs.get('transformation', ''))
        replacements['FOUNDER_INVITATION'] = clean(fs.get('invitation', ''))

    # ==========================================
    # 5. MULTIROW 2 (The Closer)
    # ==========================================
    if 'multirow_2' in draft:
        m2 = draft['multirow_2']
        replacements['MULTIROW_2_HEADING'] = clean(m2.get('heading', ''))
        replacements['MULTIROW_2_PARAGRAPH_1'] = clean(m2.get('p1', ''))
        replacements['MULTIROW_2_PARAGRAPH_2'] = clean(m2.get('p2', ''))


    # ==========================================
    # 5. TIKTOK BUBBLES
    # ==========================================
    if 'tiktok_bubbles' in draft:
        bubbles = draft['tiktok_bubbles']
        # Direct mapping
        for k, v in bubbles.items():
            replacements[k] = clean(v)

    # ==========================================
    # 6. REVIEWS (Rolling & Main)
    # ==========================================
    if 'rolling_reviews' in draft:
        for i, review in enumerate(draft['rolling_reviews']):
            if i < 5: # Limit to 5
                replacements[f'ROTATING_TESTIMONIAL_{i+1}'] = clean(review)

    # Order Bump
    if 'order_bump_desc' in draft:
        replacements['ORDER_BUMP_DESC'] = clean(draft['order_bump_desc'])

    # Comparison / Bridge
    if 'comparison' in draft:
        replacements['COMPARISON_HEADLINE'] = clean(draft['comparison'].get('headline', ''))
        replacements['COMPARISON_PARAGRAPH'] = clean(draft['comparison'].get('body', ''))
        # Default Single Image Path (Match Manifest)
        replacements['COMPARISON_IMAGE'] = "images/comparison/comparison-01.webp"

    # ==========================================
    # 7. IMAGE MAPPING (DEFAULT PATHS)
    # ==========================================
    # Feature + Secret images (testimonial pool)
    replacements['FEATURE_IMAGE_1'] = "images/testimonials/testimonial-01.webp"
    replacements['FEATURE_IMAGE_2'] = "images/testimonials/testimonial-02.webp"
    replacements['FEATURE_IMAGE_3'] = "images/testimonials/testimonial-03.webp"

    replacements['SECRET_IMAGE_1'] = "images/testimonials/testimonial-04.webp"
    replacements['SECRET_IMAGE_2'] = "images/testimonials/testimonial-05.webp"
    replacements['SECRET_IMAGE_3'] = "images/testimonials/testimonial-06.webp"

    # Main testimonials (12 slots)
    replacements['TESTIMONIAL_1_IMAGE'] = "images/testimonials/testimonial-07.webp"
    replacements['TESTIMONIAL_2_IMAGE'] = "images/testimonials/testimonial-08.webp"
    replacements['TESTIMONIAL_3_IMAGE'] = "images/testimonials/testimonial-09.webp"
    replacements['TESTIMONIAL_4_IMAGE'] = "images/testimonials/testimonial-10.webp"
    replacements['TESTIMONIAL_5_IMAGE'] = "images/testimonials/testimonial-11.webp"
    replacements['TESTIMONIAL_6_IMAGE'] = "images/testimonials/testimonial-12.webp"
    replacements['TESTIMONIAL_7_IMAGE'] = "images/testimonials/testimonial-13.webp"
    replacements['TESTIMONIAL_8_IMAGE'] = "images/testimonials/testimonial-14.webp"
    replacements['TESTIMONIAL_9_IMAGE'] = "images/testimonials/testimonial-15.webp"
    replacements['TESTIMONIAL_10_IMAGE'] = "images/testimonials/testimonial-16.webp"
    replacements['TESTIMONIAL_11_IMAGE'] = "images/testimonials/testimonial-17.webp"
    replacements['TESTIMONIAL_12_IMAGE'] = "images/testimonials/testimonial-18.webp"

    # Supporting images
    replacements['CUSTOM_SECTION_IMAGE_1'] = "images/testimonials/testimonial-19.webp"
    replacements['CUSTOM_SECTION_IMAGE_2'] = "images/testimonials/testimonial-20.webp"
    replacements['SLIDESHOW_IMAGE_1'] = "images/testimonials/testimonial-21.webp"
    replacements['SLIDESHOW_IMAGE_2'] = "images/testimonials/testimonial-22.webp"
    replacements['MULTIROW_2_IMAGE'] = "images/testimonials/testimonial-23.webp"

    # Comparison / order bump / founder
    replacements['COMPARISON_IMAGE'] = "images/comparison/comparison-01.webp"
    replacements['ORDER_BUMP_IMAGE'] = "images/order-bump/order-bump-01.webp"
    replacements['FOUNDER_IMAGE'] = "images/founder/founder-01.webp"


    if 'main_reviews' in draft:
        for i, review in enumerate(draft['main_reviews']):
            if i < 12: # Limit to 12
                num = i + 1
                replacements[f'TESTIMONIAL_{num}_TITLE'] = clean(review.get('title', ''))
                replacements[f'TESTIMONIAL_{num}_QUOTE'] = clean(review.get('content', ''))
                replacements[f'TESTIMONIAL_{num}_AUTHOR'] = clean(review.get('author', ''))
                replacements[f'TESTIMONIAL_{num}_LOCATION'] = clean(review.get('location', ''))

    # ==========================================
    # APPLY TO CONFIG
    # ==========================================
    for key, value in replacements.items():
        # Regex to find KEY="Value"
        pattern = rf'^{key}=".*?"'
        replacement = f'{key}="{value}"'
        
        if re.search(pattern, config_content, re.MULTILINE):
            config_content = re.sub(pattern, replacement, config_content, flags=re.MULTILINE)
        else:
            config_content += f'\n{key}="{value}"'

    save_file('product.config', config_content)
    print("✅ product.config updated from copy_draft.json")

if __name__ == "__main__":
    main()
