import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:idara_esign/core/services/logger_service.dart';
import 'package:idara_esign/core/widgets/app_snack_bars.dart';
import 'package:idara_esign/generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactInfo {
  final String name;
  final String phone;

  const ContactInfo({required this.name, required this.phone});
}

class ContactService {
  /// Picks a single contact with a primary phone number.
  /// Handles requesting permissions and showing a built-in UI for selection.
  /// Returns null if user cancelled, denied permission, or failed.
  Future<ContactInfo?> pickContact(BuildContext context) async {
    try {
      // Always call request() first — it shows the system dialog if undetermined.
      // On Android, initial state is `denied` (not `undetermined`), so checking
      // status before request() would incorrectly skip the dialog.
      final status = await Permission.contacts.request();

      if (status.isPermanentlyDenied) {
        // iOS: triggered after the first denial (dialog won't appear again).
        // Android: triggered when user tapped "Never ask again".
        AppLog.e('Contact permission permanently denied, opening settings');
        if (context.mounted) {
          AppSnackBars.error(S.of(context).contactPermissionDenied);
          await openAppSettings();
        }
        return null;
      }

      if (!status.isGranted) {
        // User just tapped "Don't Allow" / "Deny" this time.
        AppLog.e('Contact permission denied after request');
        if (context.mounted) {
          AppSnackBars.error(S.of(context).contactPermissionDenied);
        }
        return null;
      }

      if (!context.mounted) return null;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) =>
            const Center(child: CircularProgressIndicator()),
      );

      final contacts = await FastContacts.getAllContacts();

      if (!context.mounted) return null;
      Navigator.pop(context); // close loading dialog

      // Flatten contacts into a list of specific phone numbers
      final List<Map<String, dynamic>> flattenedContacts = [];
      for (var c in contacts) {
        if (c.phones.isEmpty) continue;
        for (var phone in c.phones) {
          flattenedContacts.add({'contact': c, 'phone': phone});
        }
      }

      if (flattenedContacts.isEmpty) {
        AppSnackBars.info(S.of(context).noContactsFound);
        return null;
      }

      final selection = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      S.of(context).selectContact,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: flattenedContacts.length,
                      itemBuilder: (context, index) {
                        final item = flattenedContacts[index];
                        final Contact c = item['contact'];
                        final Phone phone = item['phone'];

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              c.displayName.isNotEmpty
                                  ? c.displayName[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(c.displayName),
                          subtitle: Text(
                            phone.label.isNotEmpty
                                ? '${phone.label}: ${phone.number}'
                                : phone.number,
                          ),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (selection != null) {
        final Contact selectedContact = selection['contact'];
        final Phone selectedPhone = selection['phone'];

        final rawPhone = selectedPhone.number;
        // Clean the phone number (remove spaces, dashes, parentheses)
        final cleanPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

        return ContactInfo(
          name: selectedContact.displayName,
          phone: cleanPhone,
        );
      }

      return null;
    } catch (e) {
      AppLog.e(e.toString());
      if (context.mounted) {
        try {
          AppSnackBars.error(S.of(context).somethingWentWrong);
        } catch (_) {
          AppSnackBars.error('Failed to load contacts: $e');
        }
      }
      return null;
    }
  }
}
