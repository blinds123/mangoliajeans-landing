#!/bin/bash
# Self-Healing: Fix Missing ENGAGE Pattern Interrupts
# Adds pattern interrupts to sections that need them

set -e

echo "=== SELF-HEALING: ENGAGE Pattern Interrupts ==="

SECTION_FILE="$1"
MIN_HOOKS="${2:-3}"

if [ -z "$SECTION_FILE" ]; then
  echo "Usage: bash fix-engage-hooks.sh <section-file> [min-hooks]"
  exit 0
fi

if [ ! -f "$SECTION_FILE" ]; then
  echo "ERROR: File '$SECTION_FILE' not found"
  exit 0
fi

# Count existing hooks
count_hooks() {
  local file="$1"
  local count=0

  # Question hooks
  count=$((count + $(grep -ciE 'what if|how can|why does|have you ever|could it be|do you ever' "$file" 2>/dev/null || echo 0)))

  # Contradiction hooks
  count=$((count + $(grep -ciE 'everyone says|most people think|you.ve been told|contrary to|the truth is' "$file" 2>/dev/null || echo 0)))

  # Stat hooks
  count=$((count + $(grep -ciE '[0-9]+%|[0-9,]+ (women|people|customers|users|studies)' "$file" 2>/dev/null || echo 0)))

  # Unexpected hooks
  count=$((count + $(grep -ciE 'you don.t need|stop|forget|instead of|throw away' "$file" 2>/dev/null || echo 0)))

  # Reader callout hooks
  count=$((count + $(grep -ciE 'if you.re reading|you already know|you.re the type' "$file" 2>/dev/null || echo 0)))

  # Confession hooks
  count=$((count + $(grep -ciE 'here.s what|nobody talks about|the secret|I.ll admit|confession' "$file" 2>/dev/null || echo 0)))

  # Time travel hooks
  count=$((count + $(grep -ciE 'imagine [0-9]+ days|picture yourself|a month from now|in just|fast forward' "$file" 2>/dev/null || echo 0)))

  # Permission hooks
  count=$((count + $(grep -ciE 'stop .*, start|it.s okay to|you have permission|you.re allowed' "$file" 2>/dev/null || echo 0)))

  echo $count
}

CURRENT_HOOKS=$(count_hooks "$SECTION_FILE")
echo "Current pattern interrupts: $CURRENT_HOOKS"
echo "Required minimum: $MIN_HOOKS"

if [ "$CURRENT_HOOKS" -ge "$MIN_HOOKS" ]; then
  echo "PASS: Sufficient pattern interrupts"
  exit 0
fi

NEEDED=$((MIN_HOOKS - CURRENT_HOOKS))
echo ""
echo "NEED TO ADD: $NEEDED more pattern interrupts"
echo ""

# Provide suggestions based on section type
SECTION_NAME=$(basename "$SECTION_FILE" .html)

echo "=== SUGGESTED PATTERN INTERRUPTS ==="
echo ""
echo "Choose from these 8 types (Perry Belcher ENGAGE Framework):"
echo ""

cat << 'HOOKS'
1. QUESTION HOOKS (Provoke curiosity)
   - "What if everything you knew about [topic] was wrong?"
   - "Have you ever wondered why [problem] keeps happening?"
   - "Could it be that [unexpected insight]?"

2. CONTRADICTION HOOKS (Challenge beliefs)
   - "Everyone says you need [common belief]. They're wrong."
   - "You've been told [myth]. Here's the truth..."
   - "Contrary to popular belief, [surprising fact]"

3. STATISTIC HOOKS (Prove with numbers)
   - "97% of women who tried this saw results in 30 days"
   - "Over 50,000 customers can't be wrong"
   - "Studies show [compelling statistic]"

4. UNEXPECTED HOOKS (Surprise them)
   - "You don't need [expected solution]"
   - "Stop [common action]. Do this instead."
   - "Forget everything you know about [topic]"

5. READER CALLOUT HOOKS (Personal connection)
   - "If you're reading this, you already know something is off"
   - "You're the type of person who [positive trait]"
   - "This is for women who are tired of [problem]"

6. CONFESSION HOOKS (Build trust)
   - "Here's what no one talks about..."
   - "The secret the industry doesn't want you to know"
   - "I'll admit, I was skeptical too at first"

7. TIME TRAVEL HOOKS (Future pacing)
   - "Imagine 30 days from now, looking in the mirror..."
   - "Picture yourself finally [desired outcome]"
   - "Fast forward to next month when [result]"

8. PERMISSION HOOKS (Remove guilt)
   - "It's okay to want [desire] for yourself"
   - "You have permission to [action]"
   - "Stop feeling guilty about [thing], start [action]"
HOOKS

echo ""
echo "=== INTEGRATION GUIDE ==="
echo ""
echo "For section: $SECTION_NAME"
echo ""

case "$SECTION_NAME" in
  *hero*)
    echo "HERO: Use Question + Statistic + Time Travel"
    echo "Example: 'What if you could [benefit] in just 30 days?'"
    ;;
  *big-domino*)
    echo "BIG DOMINO: Use Contradiction + Confession + Unexpected"
    echo "Example: 'Everyone says you need [myth]. Here's what really works...'"
    ;;
  *secret*|*vehicle*|*internal*|*external*)
    echo "3 SECRETS: Use Confession + Unexpected + Permission"
    echo "Example: 'Here's what nobody tells you about [secret topic]...'"
    ;;
  *epiphany*)
    echo "EPIPHANY BRIDGE: Use Time Travel + Reader Callout + Question"
    echo "Example: 'Have you ever felt like [relatable feeling]?'"
    ;;
  *testimonial*)
    echo "TESTIMONIALS: Use Statistic + Reader Callout + Question"
    echo "Example: 'Join 10,000+ women who discovered...'"
    ;;
  *comparison*)
    echo "COMPARISON: Use Contradiction + Statistic + Unexpected"
    echo "Example: 'Stop wasting money on [old solution]...'"
    ;;
  *cta*|*urgency*)
    echo "CTA/URGENCY: Use Time Travel + Permission + Statistic"
    echo "Example: 'Imagine waking up tomorrow with [result]...'"
    ;;
  *)
    echo "GENERAL: Mix 3 different hook types for variety"
    ;;
esac

echo ""
echo "=== FIX ACTIONS ==="
echo "1. Edit $SECTION_FILE"
echo "2. Add $NEEDED pattern interrupts from the list above"
echo "3. Place hooks at start of paragraphs for maximum impact"
echo "4. Re-run validation: bash tests/validate-engage.sh $SECTION_FILE $MIN_HOOKS"

exit 0
