# Accuracy Circle

A Flutter package that provides a customizable circular progress indicator with animation and a clean gap effect.

![demo](https://user-images.githubusercontent.com/xxx/demo.gif)

---

## ✨ Features
- Circular progress indicator with gap between progress & background
- Smooth animation
- Configurable size, stroke width, and colors
- Always keeps a visible gap until reaching 100%

---

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  accuracy_circle:
    git:
      url: https://github.com/libawo-dev-sudo/accuracy-circle.git



---

## 📄 `example/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:accuracy_circle/accuracy_circle.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Accuracy Circle Example")),
        body: Center(
          child: AccuracyCircle(
            percentage: 85,
            size: 120,
            strokeWidth: 10,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
