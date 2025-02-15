import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/oss_licenses.dart';
import 'package:what_the_banana/ui/back_button.dart';

class OssLicensesView extends StatelessWidget {
  const OssLicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.homeMainBackground,
      appBar: AppBar(
        title: Text(
          'Open Source Licenses',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24),
        ),
        backgroundColor: ColorName.homeMainBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackImage(context),
        toolbarHeight: 48,
      ),
      body: ListView.builder(
        itemCount: allDependencies.length,
        itemBuilder: (context, index) {
          final package = allDependencies[index];
          return ListTile(
            title: Text(
              '${package.name} ${package.version}',
              style: const TextStyle(fontFamily: FontFamily.inter, fontSize: 18),
            ),
            subtitle: package.description.isNotEmpty
                ? Text(
                    package.description,
                    style: const TextStyle(fontFamily: FontFamily.inter),
                  )
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (context) => MiscOssLicenseSingle(package: package),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MiscOssLicenseSingle extends StatelessWidget {
  const MiscOssLicenseSingle({required this.package, super.key});

  final Package package;

  String _bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      return line.trim();
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${package.name} ${package.version}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ColorName.homeMainBackground,
        leading: BackImage(context),
        toolbarHeight: 48,
      ),
      backgroundColor: ColorName.homeMainBackground,
      body: ColoredBox(
        color: ColorName.homeMainBackground,
        child: ListView(
          children: <Widget>[
            if (package.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: Text(
                  package.description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.inter,
                      ),
                ),
              ),
            if (package.homepage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: InkWell(
                  child: Text(
                    package.homepage!,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () => launchUrl(
                    Uri.parse(package.homepage ?? ''),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            if (package.description.isNotEmpty || package.homepage != null)
              const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Text(
                _bodyText(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: FontFamily.inter,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
