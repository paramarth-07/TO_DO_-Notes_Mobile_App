import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskFlowApp());
}

/// Root Application Widget configuring Material 3 and Warm Minimal Tactile Theme.
class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do&notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DeviceFrameWrapper(
        child: MainScreen(),
      ),
    );
  }
}

/// Responsive Device Mockup Wrapper
/// Renders a sleek smartphone mockup frame when viewed on desktop/browser
/// (matching the YouTuber's live workbench preview), and full-screen on mobile.
class DeviceFrameWrapper extends StatelessWidget {
  final Widget child;

  const DeviceFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If window is wide (desktop browser/IDE), wrap in a sleek phone frame
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFF18181B), // Antigravity Dark Canvas
            body: Center(
              child: Container(
                width: 412,
                height: 860,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(
                    color: const Color(0xFF27272A),
                    width: 7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 36,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: Stack(
                    children: [
                      child,
                      // Android centered punch-hole camera
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1F1F1F),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFF14213D),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Android bottom gesture navigation pill
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          width: 108,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // On mobile devices or narrow viewport, fill the whole display
        return child;
      },
    );
  }
}
