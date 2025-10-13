# Adaptive Navigation (Bar & Rail) + Overflow

Provide a single list of **destinations** (5–7 total). On **phones**, show the top 3–5 as a **NavigationBar** and expose the rest via a **modal NavigationDrawer** (or a “More” page). On **tablets/desktops**, use a **NavigationRail**.

## Destination Model (single source of truth)

```dart
class NavDestination {
  final String routeName; // auto_route path or a generated route class name
  final IconData icon;
  final String label;
  final bool primary; // if true, eligible for phone bar

  const NavDestination({
    required this.routeName,
    required this.icon,
    required this.label,
    this.primary = true,
  });
}
```

Your app defines ~5–7 destinations. Mark the most important **primary=true** (≤5). Others will be **overflow** on phones.

## Phone (compact): NavigationBar + Drawer (overflow)

```dart
class PhoneScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final List<NavDestination> destinations; // all
  final Widget body;

  const PhoneScaffold({
    super.key,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final primary = destinations.where((d) => d.primary).take(5).toList();
    final overflow = destinations.where((d) => !d.primary || !primary.contains(d)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
        leading: overflow.isEmpty
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
      ),
      drawer: overflow.isEmpty
          ? null
          : NavigationDrawer(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Mehr', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...overflow.map((d) => ListTile(
                      leading: Icon(d.icon),
                      title: Text(d.label),
                      onTap: () {
                        Navigator.of(context).maybePop(); // close drawer
                        // use auto_route navigation
                        // context.router.replaceNamed(d.routeName);
                      },
                    )),
              ],
            ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelectIndex,
        destinations: [
          for (final d in primary)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }
}
```

- Put **≤5 primary** items into the bottom bar.
- Put remaining items into a **modal NavigationDrawer** (or a “More” page) as overflow.

## Tablet/Desktop (medium/expanded): NavigationRail

```dart
class RailScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final List<NavDestination> destinations; // all
  final Widget body;
  final bool extended; // show labels always (desktop)

  const RailScaffold({
    super.key,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.destinations,
    required this.body,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelectIndex,
            labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
            extended: extended,
            destinations: [
              for (final d in destinations.where((d) => d.primary))
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
```

### Notes
- Consider **`extended: true`** on desktop to always show labels.
- Keep **bar/rail selection state** in sync with your router (see `auto_route` doc).
- The **drawer** is typically not shown on rail layouts; all main items fit the rail. Overflow items can appear as **rail trailing** actions or be grouped elsewhere.