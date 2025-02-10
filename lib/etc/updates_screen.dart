import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List<Map<String, String>> updates = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAssetsFromFolder().then((paths) {
        if (!mounted) return;
        final currentLanguage = context.locale.toString();

        for (final jsonFilePath in paths.reversed) {
          rootBundle.load(jsonFilePath).then((data) {
            final jsonString = data.buffer.asUint8List();
            final json =
                jsonDecode(utf8.decode(jsonString)) as Map<String, dynamic>;

            setState(() {
              updates.add({
                'version': jsonFilePath.split('/').last.replaceAll('.json', ''),
                'date': json['date'] as String,
                'content':
                    json[currentLanguage] as String? ?? json['en'] as String,
              });
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'updates',
          style: Theme.of(context).textTheme.bodyLarge,
        ).tr(),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: updates.map((update) {
              return Column(
                children: [
                  Text(update['version']!),
                  Text(update['date']!),
                  Text(update['content']!),
                  const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<List<String>> getAssetsFromFolder() async {
    // AssetManifest.json 로드
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    // 특정 폴더(`folder`) 내에 포함된 파일만 필터링하여 리스트 반환
    return manifestMap.keys
        .where((String key) => key.startsWith('assets/update_notes/'))
        .toList();
  }
}
