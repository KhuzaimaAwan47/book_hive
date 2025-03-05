import 'package:bookhive/auth/database_helper.dart';
import 'package:bookhive/models/books_model.dart';
import 'package:bookhive/providers/favorites_provider.dart';
import 'package:bookhive/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingBooksWidget extends StatelessWidget {
  const TrendingBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: ApiService().fetchBooks('flutter'), // Change query as needed (harry+potter, programming, data+science). Here only flutter related books are displayed.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final books = snapshot.data ?? [];
        if (books.isEmpty) {
          return const Center(child: Text('No trending books available.'));
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
                subtitle: Text(book.authors.join(', ',)),
                trailing: IconButton(
                    onPressed: () async {
                      await Provider.of<FavoriteBooksProvider>(context, listen: false).addFavorite(book);
                     // await DatabaseHelper().insertFavorite(book);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating, // Make it float
                            margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                            duration: Duration(seconds: 3),
                            content: Text('Book saved to favorites!')),
                      );
                    },
                    icon: Icon(Icons.favorite_border)),
              ),
            );
          },
        );
      },
    );
  }
}