import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'gif/gif_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gifState = ref.watch(gifProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenGIF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () => context.push('/upload'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search GIFs",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                ref.read(gifProvider.notifier).searchGifs(value);
              },
            ),
          ),
          Expanded(
            child: gifState.when(
              data: (gifs) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: gifs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            gifs[index].url,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.error),
                          ),
                        ),
                        Text(gifs[index].title),
                      ],
                    ),
                  );
                },
              ),
              error: (err, stack) => Center(child: Text("Error: $err")),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
