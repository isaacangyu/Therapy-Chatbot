// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Forked from: https://github.com/flutter/samples

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/util/global.dart';
import '/util/theme.dart';

bool _isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > Global.largeScreenThreshold;
}

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > Global.mediumScreenThreshold;
}

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;

  const AdaptiveScaffoldDestination({required this.title, required this.icon});
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// [NavigationRail], or [BottomNavigationBar]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final Widget? title; // Appears above navigation rail.
  final List<Widget> actions; // Appears in the top left corner above the app bar.
  final Widget? body;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final FloatingActionButton? floatingActionButton; // Appears in the bottom right corner.

  const AdaptiveScaffold({
    this.title,
    this.body,
    this.actions = const [],
    required this.currentIndex,
    required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
    super.key,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.watch<CustomAppTheme>();
    
    // Show a Drawer
    if (_isLargeScreen(context)) {
      return Row(
        children: [
          Drawer(
            width: 200,
            backgroundColor: theme.colorScheme.primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Column(
              children: [
                widget.title != null 
                  // ? DrawerHeader(child: Center(child: widget.title)) 
                  ? Center(child: widget.title) 
                  : const SizedBox.shrink(),
                for (var d in widget.destinations)
                  ListTile(
                    leading: Icon(d.icon, color: customTheme.inactiveColor),
                    title: Text(
                      d.title, 
                      style: theme.textTheme.labelLarge!.copyWith(color: customTheme.inactiveColor)
                    ),
                    selected:
                        widget.destinations.indexOf(d) == widget.currentIndex,
                    onTap: () => _destinationTapped(d),
                  ),
              ],
            ),
          ),
          // VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),
          Expanded(
            child: Scaffold(
              appBar: widget.actions.isEmpty ? null : AppBar(actions: widget.actions),
              body: widget.body,
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
        ],
      );
    }

    // Show a navigation rail
    if (_isMediumScreen(context)) {
      var shouldExtend = MediaQuery.of(context).size.width 
        >= Global.navigationRailExtendedThreshold;
      return Scaffold(
        // appBar: AppBar(title: widget.title, actions: widget.actions),
        body: Row(
          children: [
            SizedBox(
              width: shouldExtend ? 160 : 100,
              child: NavigationRail(
                backgroundColor: theme.colorScheme.primary,
                extended: shouldExtend,
                leading: widget.floatingActionButton,
                destinations: [
                  ...widget.destinations.map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon, color: customTheme.inactiveColor),
                      label: Text(
                        d.title, 
                        style: theme.textTheme.labelLarge!.copyWith(color: customTheme.inactiveColor)
                      ),
                    ),
                  ),
                ],
                selectedIndex: widget.currentIndex,
                onDestinationSelected: widget.onNavigationIndexChange ?? (_) {},
              ),
            ),
            // VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),
            Expanded(child: widget.body!),
          ],
        ),
      );
    }

    // Show a bottom app bar
    return Scaffold(
      body: widget.body,
      // appBar: AppBar(title: widget.title, actions: widget.actions),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: customTheme.inactiveColor,
        unselectedItemColor: customTheme.activeColor,
        items: [
          ...widget.destinations.map(
            (d) => BottomNavigationBarItem(
              icon: Icon(d.icon), 
              label: d.title
            ),
          ),
        ],
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationIndexChange,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange!(idx);
    }
  }
}
