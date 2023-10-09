import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.itemShape = const StadiumBorder(),
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

  });

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<CustomBottomNavBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The background color of the bar.
  final Color? backgroundColor;

  /// The color of the icon and text when the item is selected.
  final Color? selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color? unselectedItemColor;

  /// The opacity of color of the touchable background when the item is selected.
  final double? selectedColorOpacity;

  /// The border shape of each item.
  final ShapeBorder itemShape;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black,
            ],
            begin: Alignment.topCenter,end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in items)
              TweenAnimationBuilder<double>(
                tween: Tween(
                  end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
                ),
                curve: Curves.slowMiddle,
                duration: const Duration(microseconds: 1),
                builder: (context, t, _) {
                  final selectedColor = item.selectedColor ??
                      selectedItemColor ??
                      theme.primaryColor;
            
                  final unselectedColor = item.unselectedColor ??
                      unselectedItemColor ??
                      theme.iconTheme.color;
            
                  return InkWell(
                    onTap: () => onTap?.call(items.indexOf(item)),
                    customBorder: itemShape,
                    focusColor: selectedColor.withOpacity(0.1),
                    highlightColor: selectedColor.withOpacity(0.1),
                    splashColor: selectedColor.withOpacity(0.1),
                    hoverColor: selectedColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                Colors.grey.shade400,
                                selectedColor,
                                t,
                              ),
                              size: 24,
                            ),
                            child: items.indexOf(item) == currentIndex
                                ? item.selectedIcon
                                : item.icon,
                          ),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.grey.shade700,
                                selectedColor,
                                t,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                            child: item.title,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// A tab to display in a [CustomBottomNavBar]
class CustomBottomNavBarItem {
  /// An icon to display.
  final Widget icon;

  /// An icon to display when this tab bar is active.
  final Widget? activeIcon;

  /// Text to display, ie `Home`
  final Widget title;

  /// A primary color to use for this tab.
  final Color? selectedColor;

  /// The color to display when this tab is not selected.
  final Color? unselectedColor;

  //
  final Icon selectedIcon;

  CustomBottomNavBarItem({
    required this.selectedIcon,
    required this.icon,
    required this.title,
    this.selectedColor,
    this.unselectedColor,
    this.activeIcon,
  });
}
