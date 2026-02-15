---
name: profiler
description: Create detailed customer profile with day-in-the-life scenarios. Auto-activates on "create profile", "customer profile", "profiler".
---

# Profiler - Customer Profile

## Purpose

Create detailed customer profile for copy targeting.

## INPUT

- context/competitor_funnels.json

## STEP 1: Define Demographics

```
Age range:
Gender:
Location:
Income level:
Occupation:
```

## STEP 2: Create Day-in-the-Life

Describe a typical day showing when they encounter the problem:

- Morning routine
- Work/daily activities
- Evening/when problem is worst
- Triggers that make them think about solution

## STEP 3: Document Voice Patterns

How do they talk about this problem:

- Casual/formal
- Emotional/logical
- Technical/simple
- Specific phrases they use

## OUTPUT

Create `context/customer_profile.json`:

```json
{
  "demographics": {
    "age_range": "[Range]",
    "gender": "[Primary gender or both]",
    "location": "[Geographic focus]",
    "income_level": "[Level]",
    "occupation": "[Common occupations]"
  },
  "day_in_the_life": {
    "morning": "[What happens in morning related to problem]",
    "midday": "[Midday experience]",
    "evening": "[Evening when problem peaks]",
    "trigger_moments": ["[Trigger 1]", "[Trigger 2]", "[Trigger 3]"]
  },
  "voice_patterns": {
    "tone": "[Casual/formal/etc]",
    "emotion_level": "[High/medium/low]",
    "vocabulary": "[Simple/technical/etc]",
    "sample_phrases": ["[Phrase 1]", "[Phrase 2]", "[Phrase 3]"]
  }
}
```

## PASS CONDITION

- demographics complete
- day_in_the_life has all 4 sections
- voice_patterns has sample_phrases
