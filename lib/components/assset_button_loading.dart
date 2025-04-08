import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class MyLoadingButton extends StatefulWidget {
  final Future<void> Function()? onTap; // Fungsi async
  final String label;
  final Color color;
  final double width;

  const MyLoadingButton({
    super.key,
    required this.onTap,
    required this.label,
    this.color = AppColors.accentColor, // Warna default
    this.width = 150.0, // Lebar default
  });

  @override
  _MyLoadingButtonState createState() => _MyLoadingButtonState();
}

class _MyLoadingButtonState extends State<MyLoadingButton> {
  bool _isLoading = false;

  void _handleTap() async {
    if (_isLoading || widget.onTap == null) return;

    setState(() => _isLoading = true);

    try {
      await widget.onTap?.call();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleTap,
      child: Container(
        width: widget.width,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : widget.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    widget.label,
                    key: ValueKey(widget.label),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
