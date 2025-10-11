# INDI

INDI Diagnostics Tool.

---

## Development Setup

1. Install Flutter
2. Clone this repo
3. Run the following commands

```bash

# For code generation
dart run build_runner build

# For Windows and Linux
flutter create --platforms=windows,linux .

# For dependencies
flutter pub get

```

---

## Build Release

### Windows
```bash
flutter build windows --release
```

### Linux
```bash
flutter build linux --release
```