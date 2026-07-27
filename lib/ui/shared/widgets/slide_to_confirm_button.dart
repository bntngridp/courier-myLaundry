import 'package:flutter/material.dart';

/// Reusable Slide To Confirm / Slide Action Button with smooth drag animation.
class SlideToConfirmButton extends StatefulWidget {
  final String text;
  final VoidCallback onConfirmed;
  final bool isLoading;
  final Color backgroundColor;
  final Color sliderColor;
  final Color iconColor;
  final Color textColor;
  final double height;
  final IconData icon;

  const SlideToConfirmButton({
    super.key,
    required this.text,
    required this.onConfirmed,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFE0E7FF),
    this.sliderColor = const Color(0xFF0007B0),
    this.iconColor = Colors.white,
    this.textColor = const Color(0xFF0007B0),
    this.height = 58.0,
    this.icon = Icons.double_arrow_rounded,
  });

  @override
  State<SlideToConfirmButton> createState() => _SlideToConfirmButtonState();
}

class _SlideToConfirmButtonState extends State<SlideToConfirmButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  double _dragPosition = 0.0;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animController.addListener(() {
      setState(() {
        _dragPosition = _slideAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _resetSlider() {
    _slideAnimation = Tween<double>(begin: _dragPosition, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0.0);
    if (mounted) {
      setState(() {
        _isSubmitted = false;
      });
    }
  }

  void _completeSlider(double maxDrag) {
    _slideAnimation = Tween<double>(begin: _dragPosition, end: maxDrag).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward(from: 0.0).then((_) {
      if (!_isSubmitted && mounted) {
        setState(() {
          _isSubmitted = true;
        });
        widget.onConfirmed();
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) _resetSlider();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.sliderColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxTrackWidth = constraints.maxWidth;
        final handleSize = widget.height - 8;
        final maxDragDistance = maxTrackWidth - handleSize - 8;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Active fill background track
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: (_dragPosition + handleSize + 8).clamp(widget.height, maxTrackWidth),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.sliderColor,
                        _isSubmitted ? const Color(0xFF4CAF50) : widget.sliderColor.withValues(alpha: 0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
              ),

              // Animated Label (fades out as handle moves)
              Center(
                child: Opacity(
                  opacity: (1.0 - (_dragPosition / (maxDragDistance * 0.6))).clamp(0.0, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: widget.textColor.withValues(alpha: 0.7),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // Sliding Handle (Draggable)
              Positioned(
                left: 4 + _dragPosition,
                top: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_isSubmitted) return;
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDragDistance);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isSubmitted) return;
                    if (_dragPosition >= maxDragDistance * 0.7) {
                      _completeSlider(maxDragDistance);
                    } else {
                      _resetSlider();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: handleSize,
                    height: handleSize,
                    decoration: BoxDecoration(
                      color: _isSubmitted ? const Color(0xFF4CAF50) : widget.sliderColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isSubmitted ? const Color(0xFF4CAF50) : widget.sliderColor).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSubmitted ? Icons.check_rounded : widget.icon,
                      color: widget.iconColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
