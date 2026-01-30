import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'gif/gif_state.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Upload GIF")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'id',
                decoration: const InputDecoration(labelText: 'Unique ID'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(labelText: 'Title'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'url',
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.url(),
                ]),
              ),
              const SizedBox(height: 10),
              // Tags as a comma-separated string for simplicity
              FormBuilderTextField(
                name: 'tags',
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = formKey.currentState!.value;

                    // Convert basic map to match Go Struct
                    final uploadData = {
                      "id": formData['id'],
                      "title": formData['title'],
                      "url": formData['url'],
                      "tags": (formData['tags'] as String?)?.split(',') ?? [],
                    };

                    final success = await ref
                        .read(gifProvider.notifier)
                        .uploadGif(uploadData);

                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Uploaded!")),
                      );
                      context.pop();
                    }
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
