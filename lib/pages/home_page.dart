import 'package:bookhive/pages/favorites_books.dart';
import 'package:bookhive/pages/search_result.dart';
import 'package:bookhive/pages/trending_books.dart';
import 'package:bookhive/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState  extends State<HomePage>{
final TextEditingController _searchController = TextEditingController();

void _performSearch(BuildContext context) {
  if (_searchController.text.trim().isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(query: _searchController.text.trim()),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
   return Scaffold(
     appBar: AppBar(
       automaticallyImplyLeading: false,
       title: Text('Book Hive'),
       actions: [
         PopupMenuButton<String>(
           color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
           onSelected: (value) {
             if (value == 'item1') {
               Provider.of<ThemeManager>(context, listen: false).toggleTheme();
             } else if (value == 'item2') {
               Navigator.pop(context,);
             }
           },
           itemBuilder: (BuildContext context) {
             return [
               PopupMenuItem<String>(
                 value: 'item1',
                 child: Row(
                   children: [
                     Icon(Icons.brightness_6,color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,),
                     SizedBox(width: 10,),
                     Text('Change Theme',style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
                   ],
                 ),
               ),
               PopupMenuItem<String>(
                 value: 'item2',
                 child: Row(
                   children: [
                     Icon(Icons.logout,color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,),
                     SizedBox(width: 10,),
                     Text('Sign out',style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
                   ],
                 ),
               ),
             ];
           },
           offset:  Offset(0, kToolbarHeight),   // This places the dropdown slightly below the app bar.
         )
       ],
     ),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             TextFormField(
               controller: _searchController,
               decoration: InputDecoration(
                 hintText: 'Search for a book',
                 hintStyle: Theme.of(context).brightness == Brightness.dark
                     ? const TextStyle(color: Colors.grey)
                     : null,
                 fillColor: Theme.of(context).brightness == Brightness.dark
                     ? Colors.grey[800]
                     : Colors.grey[200],
                 filled: true,
                 suffixIcon: IconButton(
                     onPressed: (){
                       _performSearch(context);
                     },
                     icon: Icon(Icons.search)),
                 contentPadding: EdgeInsets.all(16),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(16),
                   borderSide: BorderSide.none
                 )
               ),
               onFieldSubmitted: (_) => _performSearch(context),
             ),
             SizedBox(height: 10,),
             Text('Favorites Books',style: currentTheme.textTheme.headlineMedium,),
             SizedBox(height: 10,),
             FavoritesBooksWidget(),
             Text('Trending Books',style: currentTheme.textTheme.headlineMedium,),
             SizedBox(height: 10,),
             TrendingBooksWidget(),
           ],
         ),
       ),
     ),
   );
  }
}




