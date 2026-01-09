import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieNavItem extends StatefulWidget {
  final String lottieAsset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedLabelColor;
  final Color? unselectedLabelColor;

  const LottieNavItem({
    super.key,
    required this.lottieAsset,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedLabelColor,
    this.unselectedLabelColor,
  });

  @override
  State<LottieNavItem> createState() => _LottieNavItemState();
}

class _LottieNavItemState extends State<LottieNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didUpdateWidget(LottieNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Play animation when item becomes selected
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLabelColor = widget.selectedLabelColor ?? theme.primaryColor;
    final unselectedLabelColor = widget.unselectedLabelColor ?? Colors.grey;

    return InkWell(
      onTap: () {
        widget.onTap();
        if (widget.isSelected) {
          _controller.forward(from: 0);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie animation with brightness effect
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.isSelected
                      ? Colors.white 
                      : Colors.black12,  // Darken when not selected
                  widget.isSelected ? BlendMode.dst : BlendMode.srcATop,
                ),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Lottie.asset(
                    widget.lottieAsset,
                    controller: _controller,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected ? selectedLabelColor : unselectedLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Navigation Bar with Lottie Icons
class LottieNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<LottieNavDestination> destinations;
  final Color? selectedLabelColor;
  final Color? backgroundColor;

  const LottieNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.selectedLabelColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              destinations.length,
              (index) {
                final destination = destinations[index];
                return Expanded(
                  child: LottieNavItem(
                    lottieAsset: destination.lottieAsset,
                    label: destination.label,
                    isSelected: selectedIndex == index,
                    onTap: () => onDestinationSelected(index),
                    selectedLabelColor: selectedLabelColor,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LottieNavDestination {
  final String lottieAsset;
  final String label;

  const LottieNavDestination({
    required this.lottieAsset,
    required this.label,
  });
}