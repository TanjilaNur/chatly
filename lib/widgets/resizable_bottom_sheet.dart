import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'message_screen_widget.dart';

/// A self-contained resizable bottom sheet that manages its own state
class ResizableBottomSheet extends StatefulWidget {
  const ResizableBottomSheet({
    super.key,
    this.child,
    this.onHeightChanged,
  });

  /// Optional child widget to display in the content area
  final Widget? child;

  /// Callback when height changes - passes current height factor
  final ValueChanged<double>? onHeightChanged;

  @override
  State<ResizableBottomSheet> createState() => _ResizableBottomSheetState();
}

class _ResizableBottomSheetState extends State<ResizableBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  double _currentHeightFactor = BottomSheetConstants.minHeight;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BottomSheetConstants.animationDuration,
      vsync: this,
    );
    _heightAnimation = Tween<double>(
      begin: BottomSheetConstants.minHeight,
      end: BottomSheetConstants.minHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateToHeight(double targetHeight) {
    if (_currentHeightFactor == targetHeight) return;

    _animationController.duration = BottomSheetConstants.animationDuration;

    _heightAnimation = Tween<double>(
      begin: _currentHeightFactor,
      end: targetHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.reset();
    _animationController.forward();

    setState(() {
      _currentHeightFactor = targetHeight;
    });

    // Notify parent about height change
    widget.onHeightChanged?.call(targetHeight);
  }

  // Public method for external height change requests
  void animateToHeight(double targetHeight) {
    _animateToHeight(targetHeight);
  }

  void _onHeightChangeRequest(double requestedHeight) {
    _animateToHeight(requestedHeight);
  }

  void _onPanStart(DragStartDetails details) {
    _animationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight - statusBarHeight;

    final dragDelta = -details.delta.dy / availableHeight * BottomSheetConstants.dragSensitivity;
    final newHeight = (_currentHeightFactor + dragDelta).clamp(
      BottomSheetConstants.minHeight,
      BottomSheetConstants.maxHeight,
    );

    setState(() {
      _currentHeightFactor = newHeight;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    double targetHeight;
    if (_currentHeightFactor < (BottomSheetConstants.minHeight + BottomSheetConstants.mediumHeight) / 2) {
      targetHeight = BottomSheetConstants.minHeight;
    } else if (_currentHeightFactor < (BottomSheetConstants.mediumHeight + BottomSheetConstants.maxHeight) / 2) {
      targetHeight = BottomSheetConstants.mediumHeight;
    } else {
      targetHeight = BottomSheetConstants.maxHeight;
    }

    _animateToHeight(targetHeight);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight - statusBarHeight;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          final height = _animationController.isAnimating
              ? _heightAnimation.value * availableHeight
              : _currentHeightFactor * availableHeight;

          return Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(BottomSheetConstants.borderRadius),
                topRight: Radius.circular(BottomSheetConstants.borderRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDragHandle(),
                Expanded(
                  child: widget.child ?? MessageScreenWidget(
                    onHeightChangeRequest: _onHeightChangeRequest,
                    currentHeightFactor: _currentHeightFactor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: BottomSheetConstants.dragHandlePadding),
      child: Center(
        child: Container(
          width: BottomSheetConstants.dragHandleWidth,
          height: BottomSheetConstants.dragHandleHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
