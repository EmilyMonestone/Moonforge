# Two‑Pane (Master–Detail) Layout

Show an optional **detail pane** beside the main content when there’s enough width; otherwise, open the detail as a **new page**.

## Behavior Matrix

| Size class | Detail requested? | Behavior                              |
|-----------:|:------------------:|----------------------------------------|
| Compact    | Yes                | Navigate to **detail page**            |
| Compact    | No                 | Show **master** only                   |
| Medium     | Yes                | **Side‑by‑side** master + detail       |
| Medium     | No                 | Master only                            |
| Expanded   | Yes                | **Side‑by‑side** master + detail       |
| Expanded   | No                 | Master only / placeholder in detail    |

## Conceptual API

You can implement a simple utility that decides when to render one or two panes:

```dart
class TwoPaneLayout extends StatelessWidget {
  final Widget master;
  final Widget? detail;
  final bool showDetail; // whether a detail is currently requested/selected
  final double breakpoint; // e.g., 720

  const TwoPaneLayout({
    super.key,
    required this.master,
    this.detail,
    required this.showDetail,
    this.breakpoint = 720,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final canSplit = width >= breakpoint && showDetail && detail != null;

    if (canSplit) {
      return Row(
        children: [
          SizedBox(
            width: 360, // min width for master (tunable)
            child: master,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: detail!),
        ],
      );
    }
    // Narrow or no detail requested
    return master;
  }
}
```

- On **wide screens** (`canSplit == true`), show `master | detail` side‑by‑side.
- On **narrow screens**, render only `master`. Trigger a **route push** to show detail (see `auto_route` doc).

## UX Considerations
- Provide a **placeholder** area on wide screens when no item is selected (e.g., “Select an item…”).
- Maintain **scroll and selection state** when switching from split to single page (screen resize).
- Ensure **Back** closes the detail (wide) or pops the detail page (narrow).
- Use **accessible semantics**: indicate selection and region roles for assistive tech.