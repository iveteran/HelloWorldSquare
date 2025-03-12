# Dart Guide

## Quick fix
dart fix --dry-run
dart fix --apply

## Code format
dart format path1 path2 [...]

## Dart package manager

### Add package
dart pub add <PACKAGE_NAME>

### Get/Update dependency packages
dart pub get
dart pub update [PACKAGE_NAME]

### Create package
dart create -t package <PACKAGE_NAME>

### Publish package
dart pub publish [--dry-run]

### List workspace
dart pub workspace list

## Dart application manager

### Create console application
dart create -t console <APPLICATION_NAME>
dart create <APPLICATION_NAME>

### Create web application
1. Install webdev
dart pub global activate webdev
export PATH="$PATH":"$HOME/.pub-cache/bin"

2. Create project
dart create -t web quickstart

3. Run
cd quickstart
webdev serve
OR: webdev serve web:8088

4. Build
webdev build

### Run Dart application
cd project_name
dart run

### Compile application, e.g.
dart compile exe bin/cli.dart

### Environment usage examples
dart run --define=DEBUG=true -DFLAVOR=free main.dart
dart compile exe --define=DEBUG=true -DFLAVOR=free main.dart
dart compile js --define=DEBUG=true -DFLAVOR=free main.dart
dart compile aot-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
dart compile jit-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
dart compile kernel --define=DEBUG=true -DFLAVOR=free main.dart

## Other usages
1. dart info
2. dart analyze
3. dart test
