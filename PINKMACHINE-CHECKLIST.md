# Pink Machine Workflow Checklist

## PRE-FLIGHT CHECK
- [ ] Product name confirmed
- [ ] Target avatar defined
- [ ] Workspace created

## PHASE 1: RESEARCH ✅
- [ ] TikTok research complete
- [ ] Competitor analysis complete
- [ ] Unified research JSON created

## PHASE 2: STRATEGY COUNCIL ✅
- [ ] Council members spawned
- [ ] Pricing decided
- [ ] Headline approved
- [ ] 3 Secrets defined

## PHASE 3: COPYWRITING ✅
- [ ] product.config populated
- [ ] All placeholders filled
- [ ] Copy reviewed

## PHASE 4: IMAGE GENERATION ✅
- [ ] Whisk prompts generated
- [ ] Images generated (37 total)
- [ ] **BUBBLES ADDED** ⬅️ DON'T SKIP
- [ ] **CONVERTED TO WEBP** ⬅️ DON'T SKIP
- [ ] Images sorted into folders

## PHASE 5: BUILD & DEPLOY ✅
- [ ] index.html built
- [ ] Zero placeholders remaining
- [ ] Deployed to Netlify
- [ ] E2E tests pass

## VALIDATION GATES

### Gate 1: Pre-Build
```bash
grep -c "{{" index.html  # Must be 0
```

### Gate 2: Pre-Deploy
```bash
ls images/testimonials_bubbles/*.png | wc -l  # Must be 25
ls images/*.webp | wc -l  # Must have WebP versions
```

### Gate 3: Post-Deploy
- [ ] Page loads
- [ ] Images visible
- [ ] No broken images

## HOW TO PREVENT SKIPPING STEPS

1. **Use this checklist** - Check off each item before proceeding
2. **Run validation gates** - They catch missing steps
3. **Don't deploy until all gates pass**
4. **Add bubble step to workflow file** - Make it explicit

## SKIPPED STEPS LOG

| Date | Step Skipped | Reason | Fix |
|------|--------------|--------|-----|
| 2026-02-13 | Bubble overlay | Not numbered step | Added checklist |
| 2026-02-13 | WebP conversion | Forgot | Added checklist |
