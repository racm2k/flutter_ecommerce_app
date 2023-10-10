import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a folder name as an argument.');
    return;
  }

  final folderName = args[0];
  final basePath = 'features';
  final folderPath = '$basePath/$folderName';

  createFoldersStructure(folderPath, folderName);
}

void createFoldersStructure(String folderPath, String folderName) {
  createMainFolder(folderPath);
  createDomainFolders(folderPath, folderName);
  createPresentationFolders(folderPath, folderName);
}

void createMainFolder(String folderPath) {
  final mainFolder = Directory(folderPath);
  if (!mainFolder.existsSync()) {
    mainFolder.createSync();
    print('Created main folder: $folderPath');
  } else {
    print('Main folder already exists: $folderPath');
  }
}

void createDomainFolders(String folderPath, String folderName) {
  final domainFolder = Directory('$folderPath/domain');
  if (!domainFolder.existsSync()) {
    domainFolder.createSync(recursive: true);
    print('Created domain folder: $folderPath/domain');

    final useCasesFolder = Directory('$folderPath/domain/use_cases');
    useCasesFolder.createSync();
    print('Created use_cases folder: $folderPath/domain/use_cases');

    createUseCaseFiles(folderPath, folderName);
  } else {
    print('Domain folder already exists: $folderPath/domain');
  }
}

void createUseCaseFiles(String folderPath, String folderName) {
  final useCaseFile =
      File('$folderPath/domain/use_cases/${folderName}_use_case.dart');
  useCaseFile
      .writeAsStringSync('abstract class ${folderName.capitalize()}UseCase {}');
  print('Created file: ${folderName}_use_case.dart');

  final useCaseImplFile =
      File('$folderPath/domain/use_cases/${folderName}_use_case_impl.dart');
  useCaseImplFile.writeAsStringSync(
      'import \'${folderName}_use_case.dart\';\n\nclass ${folderName.capitalize()}UseCaseImpl implements ${folderName.capitalize()}UseCase {}');
  print('Created file: ${folderName}_use_case_impl.dart');
}

void createPresentationFolders(String folderPath, String folderName) {
  final presentationFolder = Directory('$folderPath/presentation');
  if (!presentationFolder.existsSync()) {
    presentationFolder.createSync(recursive: true);
    print('Created presentation folder: $folderPath/presentation');

    final businessComponentsFolder =
        Directory('$folderPath/presentation/business_components');
    businessComponentsFolder.createSync();
    print(
        'Created business_components folder: $folderPath/presentation/business_components');

    createBusinessComponentsFiles(businessComponentsFolder, folderName);
    final componentsFolder = Directory('$folderPath/presentation/components');
    componentsFolder.createSync();
    print('Created components folder: $folderPath/presentation/components');

    final userInterfacesFolder =
        Directory('$folderPath/presentation/user_interfaces');
    userInterfacesFolder.createSync();
    print(
        'Created user_interfaces folder: $folderPath/presentation/user_interfaces');

    createUserInterfaceFile(userInterfacesFolder, folderName);
  } else {
    print('Presentation folder already exists: $folderPath/presentation');
  }
}

void createBusinessComponentsFiles(Directory folder, String folderName) {
  final cubitFile = File('${folder.path}/${folderName}_cubit.dart');
  cubitFile.writeAsStringSync('class ${folderName.capitalize()}Cubit {}');
  print('Created file: ${folderName}_cubit.dart');

  final stateFile = File('${folder.path}/${folderName}_state.dart');
  stateFile.writeAsStringSync('class ${folderName.capitalize()}State {}');
  print('Created file: ${folderName}_state.dart');
}

void createUserInterfaceFile(Directory folder, String folderName) {
  final cartUIFile = File('${folder.path}/${folderName}_ui.dart');
  cartUIFile.writeAsStringSync(
      'import \'package:flutter/material.dart\';\n\nclass ${folderName.capitalize()}UI extends StatefulWidget {\n  const ${folderName.capitalize()}UI({Key? key}) : super(key: key);\n\n  @override\n  _${folderName.capitalize()}UIState createState() => _${folderName.capitalize()}UIState();\n}\n\nclass _${folderName.capitalize()}UIState extends State<${folderName.capitalize()}UI> {\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(\n        title: Text(\'${folderName.capitalize()} Page\'),\n      ),\n      body: Center(\n        child: Text(\'Hello, ${folderName.capitalize()}!\'),\n      ),\n    );\n  }\n}');
  print('Created file: ${folderName}_ui.dart');
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
