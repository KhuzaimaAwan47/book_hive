import 'package:bookhive/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesBooksWidget extends StatelessWidget {
  const FavoritesBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoriteBooksProvider>(context);
    if (favoritesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final books = favoritesProvider.favorites;
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
              icon: Icon(Icons.delete),
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
                          onPressed: () {
                            Provider.of<FavoriteBooksProvider>(context, listen: false).removeFavorite(book.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating, // Make it float
                                margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                                content: Text('${book.title} removed from favorites.'),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}