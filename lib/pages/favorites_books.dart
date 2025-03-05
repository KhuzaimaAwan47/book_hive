import 'package:bookhive/auth/database_helper.dart';
import 'package:bookhive/models/books_model.dart';
import 'package:flutter/material.dart';

class FavoritesBooksWidget extends StatelessWidget {
  const FavoritesBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: DatabaseHelper().getFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final books = snapshot.data ?? [];
        if (books.isEmpty) {
          return const Center(child: Text('No favorite books added yet.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: book.thumbnail.isNotEmpty
                    ? Image.network(book.thumbnail, width: 50, fit: BoxFit.cover)
                    : Container(width: 50, color: Colors.grey),
                title: Text(book.title),
                subtitle: Text(book.authors.join(', ')),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Favorite Book'),
                          content: Text('Are you sure you want to delete ${book.title} from your favorites?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await DatabaseHelper().removeFavorite(book.id);
                                Navigator.of(context).pop();

                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          },
        );
      },
    );
  }

}