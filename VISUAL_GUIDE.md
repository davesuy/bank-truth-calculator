# 🎯 Visual Guide - Bank Truth Calculator

## Your Calculator Layout

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    BANK SAVINGS COMPARISON CALCULATOR                        ║
║              Compare high-yield savings banks with traditional               ║
║                            big banks                                         ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌──────────────────────────────────┬───────────────────────────────────────────┐
│  Initial Deposit Amount          │  Number of Years                          │
│  $ [      10,000      ]          │  [        5        ]                      │
└──────────────────────────────────┴───────────────────────────────────────────┘

╔════════════════════════════════════╦═══════════════════════════════════════╗
║   📈 HIGH-YIELD BANKS              ║   🏦 TRADITIONAL BIG BANKS            ║
║   Sponsored                        ║   Low Rates                           ║
╠════════════════════════════════════╬═══════════════════════════════════════╣
║                                    ║                                       ║
║  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓    ║   ┌────────────────────────────────┐ ║
║  ┃ ✓ SELECTED                ┃    ║   │                                │ ║
║  ┃ Jenius Bank         5.25% ┃    ║   │  Chase Bank           0.01%    │ ║
║  ┃ Min: $0                   ┃    ║   │  Min: $0                       │ ║
║  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛    ║   └────────────────────────────────┘ ║
║                                    ║                                       ║
║   ┌────────────────────────────┐  ║   ┌────────────────────────────────┐ ║
║   │                            │  ║   │ ✓ SELECTED                     │ ║
║   │  CIT Bank           5.05%  │  ║   │  Bank of America      0.01%    │ ║
║   │  Min: $100                 │  ║   │  Min: $100                     │ ║
║   └────────────────────────────┘  ║   └────────────────────────────────┘ ║
║                                    ║                                       ║
║   ┌────────────────────────────┐  ║   ┌────────────────────────────────┐ ║
║   │                            │  ║   │                                │ ║
║   │  AmEx Savings       4.90%  │  ║   │  Wells Fargo          0.15%    │ ║
║   │  Min: $0                   │  ║   │  Min: $25                      │ ║
║   └────────────────────────────┘  ║   └────────────────────────────────┘ ║
║                                    ║                                       ║
║   ┌────────────────────────────┐  ║   ┌────────────────────────────────┐ ║
║   │                            │  ║   │                                │ ║
║   │  Marcus             4.75%  │  ║   │  Citibank             0.25%    │ ║
║   │  Min: $0                   │  ║   │  Min: $0                       │ ║
║   └────────────────────────────┘  ║   └────────────────────────────────┘ ║
║                                    ║                                       ║
║                                    ║   ┌────────────────────────────────┐ ║
║                                    ║   │                                │ ║
║                                    ║   │  US Bank              0.01%    │ ║
║                                    ║   │  Min: $25                      │ ║
║                                    ║   └────────────────────────────────┘ ║
╚════════════════════════════════════╩═══════════════════════════════════════╝

                         ┌───────────────────────┐
                         │   COMPARE BANKS       │
                         └───────────────────────┘

╔══════════════════════════════════════════════════════════════════════════════╗
║                          COMPARISON RESULTS                                  ║
╠════════════════════════════════════╦═════════════════════════════════════════╣
║  Jenius Bank                       ║  Bank of America                        ║
║                                    ║                                         ║
║  APY                               ║  APY                                    ║
║  5.25%                             ║  0.01%                                  ║
║                                    ║                                         ║
║  Final Amount                      ║  Final Amount                           ║
║  $12,968.71                        ║  $10,005.00                             ║
║                                    ║                                         ║
║  Interest Earned                   ║  Interest Earned                        ║
║  $2,968.71                         ║  $5.00                                  ║
╚════════════════════════════════════╩═════════════════════════════════════════╝

╔══════════════════════════════════════════════════════════════════════════════╗
║                       💰 YOU COULD EARN MORE                                 ║
║                                                                              ║
║                             $2,963.71                                        ║
║                                                                              ║
║                   with Jenius Bank over 5 years                              ║
║                                                                              ║
║                Based on $10,000.00 initial deposit                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Color Scheme

### Sponsored Banks (Left Side)
- Background: Gradient green (`from-green-50 to-emerald-50`)
- Border when selected: Green (`border-green-500`)
- Text: Dark green (`text-green-800`)
- APY number: Green (`text-green-600`)

### Low-Rate Banks (Right Side)
- Background: Gradient red (`from-red-50 to-orange-50`)
- Border when selected: Red (`border-red-500`)
- Text: Dark red (`text-red-800`)
- APY number: Red (`text-red-600`)

### Results Section
- Sponsored result: Green background (`from-green-100 to-emerald-100`)
- Low-rate result: Red background (`from-red-100 to-orange-100`)
- Difference banner: Blue-purple gradient (`from-blue-500 to-purple-600`)

## User Interaction Flow

```
START
  ↓
Enter Amount ($10,000)
  ↓
Enter Years (5)
  ↓
Click Sponsored Bank (left) → Visual feedback (green border + checkmark)
  ↓
Click Low-Rate Bank (right) → Visual feedback (red border + checkmark)
  ↓
Click "Compare Banks" button → Loading spinner appears
  ↓
API Call: POST /api/banks/compare
  ↓
Server Calculates Compound Interest
  ↓
Results Return → Display comparison
  ↓
Auto-scroll to results
  ↓
END
```

## Responsive Design

### Desktop (1024px+)
- Two-column layout side by side
- Full width bank cards
- Results displayed in grid

### Tablet (768px - 1023px)
- Two-column layout maintained
- Slightly smaller cards
- Adjusted padding

### Mobile (<768px)
- Single column stacked layout
- Sponsored banks on top
- Low-rate banks below
- Full width on small screens
- Touch-optimized buttons

## Key Visual Elements

### Selected State
✓ **Checkmark icon** appears
✓ **Colored border** (green or red)
✓ **Ring effect** around the card
✓ **"Selected" text** below bank info

### Hover State
- Card **lifts up** slightly (`translateY(-2px)`)
- **Shadow increases** for depth
- **Cursor changes** to pointer
- Smooth transition

### Loading State
- **Spinning circle** animation
- Button shows **"Calculating..."** text
- Button is **disabled** during load

### Error State
- **Red banner** at top with error message
- **Clear error text**
- **Dismissible** or auto-hide

## Typography

- **Headings:** Bold, large (text-2xl to text-4xl)
- **APY Numbers:** Extra bold, prominent (text-2xl to text-5xl)
- **Bank Names:** Bold (text-lg to text-xl)
- **Small Text:** Regular weight, gray (text-sm)
- **Font:** System font stack (Tailwind default)

## Accessibility

✓ Proper heading hierarchy
✓ Color contrast meets WCAG standards
✓ Keyboard navigation supported
✓ Screen reader friendly
✓ Focus states visible
✓ Touch targets 44px minimum

---

## Comparison to Your Original Image

### Matching Elements ✓
- Two-column layout (Sponsored vs Big Banks)
- APY percentages prominently displayed
- Bank names clearly visible
- VS separator concept
- Side-by-side comparison
- Professional appearance

### Enhancements Added ✅
- Interactive selection (clickable)
- Visual feedback on selection
- Compound interest calculator
- Detailed results display
- Responsive mobile design
- Real-time calculations
- Error handling

---

Visit: **http://localhost:8000/calculator**

