import 'package:bookhive/auth/database_helper.dart';
import 'package:bookhive/models/books_model.dart';
import 'package:bookhive/providers/favorites_provider.dart';
import 'package:bookhive/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget{
  final String query;
  const Search({
    super.key,
    required this.query,
  });

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: FutureBuilder<List<Book>>(
        future: ApiService().fetchBooks(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: book.thumbnail.isNotEmpty
                      ? Image.network(book.thumbnail, width: 50, fit: BoxFit.cover)
                      : Container(width: 50, color: Colors.grey),
                  title: Text(book.title),
                  subtitle: Text(book.authors.join(', ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () async {
                      await Provider.of<FavoriteBooksProvider>(context, listen: false).addFavorite(book);
                     // await DatabaseHelper().insertFavorite(book);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating, // Make it float
                            margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                            content: Text('Book saved to favorites!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
