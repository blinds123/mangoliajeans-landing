# Template Optimization Prompt

Use this prompt to optimize any landing page template for AI-driven workflows.

---

## THE PROMPT

Copy and paste this to any AI:

```
I have a landing page template that needs to be optimized for AI workflows. Please analyze and restructure it following these requirements:

## GOALS
1. Make the template foolproof for any AI (Gemini, Claude, GPT)
2. Create a single entry point with clear phase-based workflow
3. Remove all bloat (unused CSS, Shopify tracking, redundant files)
4. Ensure all placeholders are intuitive and well-documented
5. Create explicit file naming conventions for images

## ANALYSIS TASKS

### 1. File Structure Audit
- List all files in the template
- Identify redundant/duplicate documentation files
- Identify unused scripts, CSS, or assets
- Identify hardcoded product-specific content

### 2. Documentation Consolidation
- Create single AGENT.md as the only entry point (under 100 lines)
- Create phases/ folder with one file per workflow phase
- Remove all redundant "START HERE" or "READ THIS FIRST" files
- Ensure no conflicting instructions across files

### 3. Placeholder System
- Audit all {{PLACEHOLDER}} values in HTML files
- Create product.config with ALL placeholders documented
- Ensure build script replaces ALL placeholders
- Add examples for each placeholder

### 4. Image Workflow
For manually provided images:
- Define exact folder structure: images/product/, images/testimonials/, etc.
- Define exact file naming: product-01.png, testimonial-01.png, etc.
- List all required images with dimensions
- Ensure HTML references match these exact paths

### 5. Build Process
- Verify build.sh works without errors
- Ensure all config values are validated before build
- Remove any Shopify/platform-specific dependencies
- Test placeholder replacement

## OUTPUT STRUCTURE

Create this exact structure:

```
template/
├── AGENT.md                 ← Single entry point
├── README.md                ← Points to AGENT.md
├── product.config           ← All placeholders with docs
├── build.sh                 ← Build script
│
├── phases/
│   ├── 1-research.md       ← Buyer research
│   ├── 2-images.md         ← Image requirements + naming
│   ├── 3-config.md         ← How to fill product.config
│   ├── 4-copy.md           ← Copywriting guide
│   └── 5-build.md          ← Build and deploy
│
├── sections/               ← HTML sections
├── stylesheets/            ← CSS (cleaned)
└── images/                 ← Image folders (empty)
    ├── product/
    ├── testimonials/
    ├── comparison/
    ├── founder/
    └── order-bump/
```

## PHASE 2 IMAGE REQUIREMENTS (No AI generation)

Since I will manually provide images, create documentation that:

1. Lists ALL required images with:
   - Exact filename (e.g., product-01.png)
   - Exact dimensions (e.g., 1024x1024)
   - Purpose (e.g., "Hero product image")
   - Where it appears in the template

2. Provides a checklist I can follow:
   - [ ] product-01.png (1024x1024) - Main hero image
   - [ ] product-02.png (1024x1024) - Carousel image 2
   - etc.

3. Creates a script or process that:
   - Takes my uploaded images
   - Renames them to correct filenames
   - Moves them to correct folders
   - Converts to WebP if needed

## AI BEST PRACTICES CHECKLIST

Ensure the template follows these:

- [ ] Single entry point (AGENT.md)
- [ ] Linear phase flow (1 → 2 → 3 → 4 → 5)
- [ ] Each phase is self-contained
- [ ] No shared/repeated warnings across files
- [ ] Clear checkpoint at end of each phase
- [ ] Explicit "Next Phase: Read X.md" navigation
- [ ] All file paths are explicit (not relative)
- [ ] Examples provided for all inputs
- [ ] No Claude/GPT-specific features
- [ ] Works with any AI that can read/write files

## CLEANUP TASKS

Remove these if found:
- Shopify tracking (trekkie, monorail, TriplePixel)
- Unused CSS (predictive-search, pickup-availability, etc.)
- Unused JavaScript libraries
- Broken verification scripts
- Duplicate documentation files
- Previous product-specific content

## FINAL VALIDATION

After optimization, verify:
1. AGENT.md is under 100 lines
2. Each phase file has clear inputs/outputs
3. product.config has all fields documented
4. build.sh runs without errors
5. No hardcoded product names remain
6. All image paths in HTML match folder structure
7. Template size is minimal (remove bloat)

Start by listing all files in the template, then proceed with the analysis.
```

---

## HOW TO USE THIS PROMPT

1. **Copy the entire prompt above**
2. **Paste it to any AI** (Gemini, Claude, GPT)
3. **Provide your template folder** as context
4. **AI will restructure and optimize it**

---

## FOR MANUAL IMAGE WORKFLOW

When you provide images manually, the AI will:

1. Create `phases/2-images.md` with a checklist like:
   ```
   ## Required Images Checklist
   
   Rename your images to these exact names and place in folders:
   
   ### Product Images (images/product/)
   - [ ] product-01.png (1024x1024) - Main hero image
   - [ ] product-02.png (1024x1024) - Carousel slide 2
   - [ ] product-03.png (1024x1024) - Carousel slide 3
   - [ ] product-04.png (1024x1024) - Carousel slide 4
   - [ ] product-05.png (1024x1024) - Detail shot
   - [ ] product-06.png (1024x1024) - Lifestyle shot
   
   ### Testimonial Images (images/testimonials/)
   - [ ] testimonial-01.png (400x400) - Customer 1
   - [ ] testimonial-02.png (400x400) - Customer 2
   ... etc
   ```

2. Create a rename script:
   ```bash
   # organize-images.sh
   # Place your images in images/uploads/ then run this
   
   cd images/uploads
   
   # Rename based on your naming pattern
   mv "hero-photo.jpg" "../product/product-01.png"
   mv "lifestyle-1.jpg" "../product/product-02.png"
   # etc.
   ```

3. Update HTML to use these exact paths

---

## EXAMPLE USAGE

```
User: "Optimize this landing page template for AI workflows. I will manually provide images."

AI: "I'll analyze your template and create a structured workflow. First, let me list all files..."

[AI analyzes and restructures]

AI: "Done. Here's your optimized structure:
- AGENT.md: Single entry point
- phases/: 5 workflow phases  
- phases/2-images.md: Contains checklist of 34 images you need to provide
- organize-images.sh: Script to rename and move your images

To complete setup:
1. Read AGENT.md
2. Place your images in images/uploads/
3. Run ./organize-images.sh
4. Continue with Phase 3"
```
