import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/kids_provider.dart';
import 'custom_button.dart';
import 'bottom_navbar.dart';

class KidsProfileModal extends StatelessWidget {
  final Function(Map<String, dynamic>) onSelectChild;

  const KidsProfileModal({
    super.key,
    required this.onSelectChild,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<KidsProvider>(
      builder: (context, kidsProvider, child) {
        if (kidsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kidsProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${kidsProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final childrens = kidsProvider.kidsList;

        if (childrens.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data anak',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Inter',
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Profil Anak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: childrens.length,
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final child = childrens[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Text(
                        (child.name ?? 'N/A').substring(0, 1),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    title: Text(
                      child.name ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    subtitle: Text(
                      '${child.age ?? '?'} tahun',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () => onSelectChild(child.toMap()),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Lewati',
                onPressed: () {
                  onSelectChild({});
                },
                widthFactor: 1.0,
                color: Colors.red,
                textColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
