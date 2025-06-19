import 'package:flutter/material.dart';
import 'package:innsikt/src/features/stortinget/domain/publication_reference.dart';
import 'package:innsikt/src/utils/widget_mapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceListItem extends StatelessWidget {
  final PublicationReference reference;

  const ReferenceListItem({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final url = Uri.parse(reference.linkUrl);
        launchUrl(url);
      },
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.open_in_new),
      title: Text(reference.linkText),
    );
  }
}

class ReferenceList extends StatelessWidget {
  final List<PublicationReference> references;

  const ReferenceList({super.key, required this.references});

  @override
  Widget build(BuildContext context) {
    return WidgetMapper.col(
      references,
      (ref) => ReferenceListItem(reference: ref),
    );
  }
}
