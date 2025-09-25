import 'package:flutter/material.dart';

/// Global navigation loading state
final ValueNotifier<bool> navLoading = ValueNotifier<bool>(false);

class GlobalLoadingOverlay extends StatelessWidget {
  const GlobalLoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: navLoading,
      builder: (context, show, _) {
        if (!show) return const SizedBox.shrink();
        return IgnorePointer(
          ignoring: false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: Colors.black54,
            child: const Center(
              child: LoadingIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
          SizedBox(width: 12),
          Text(
            'Loading... ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}







