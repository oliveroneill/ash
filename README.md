# Ash - Another Story (from) HackerNews

A simple iOS app that shows a random Hacker News story when opened.
This was really an excuse to demonstrate some things I'm interested in:
- MVVM
- Codable
- IBDesignable and IBInspectable

My implementation here doesn't seem to quite fit the usual MVVM setup. I think
the view-model usually maps very closely to the view, however I've used to
states to indicate to the view what should be displayed. This means that within
the view code I'm hiding and displaying different views based on the state.
Alternatively, I could have `isHidden` variables declared in the view model.
This gives the view-model much closer coupling to the view, which has its
tradeoffs.

There's a lot of things I'd like to add to this project:
- Tests verifying request inputs
- Move all UI work to code
- Better tests around state changes
- Error propogation
- Localisation
- Accessibility

I may put this on the App Store eventually, but it's currently just a
braindump.

Contributions welcome.
