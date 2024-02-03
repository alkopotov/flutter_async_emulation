import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/product_screen.dart';
import 'package:online_shop/data/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Product>?> getAllProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return products;
  } 

  void navigateToProduct(int id) {
    Navigator.of(context).push(MaterialPageRoute
    (builder: (context) {
      return ProductScreen(id: id); 
    },
    ));
  }

  bool isCheap(double price){
    return price < 50000;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Наши лучшие товары'),
      ),
      body: FutureBuilder(
        future: getAllProducts(),
        builder: (context, snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator()
            );
         }
         if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString())
              );
          }
          if(snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Center(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //mainAxisExtent: 220,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                    ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToProduct(snapshot.data![index].id);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.4,
                          ),
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              snapshot.data![index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: snapshot.data![index].isDiscounted ? Colors.blue : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              // decoration: BoxDecoration(
                              //   border: Border.all(),
                              //   borderRadius: BorderRadius.circular(20)),
                              child: Image.network(
                                snapshot.data![index].photo,
                                fit: BoxFit.cover,
                                )
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                              child: Text(
                                '${snapshot.data![index].price.ceil().toString()}₽',
                                style: TextStyle(
                                  color: (isCheap(snapshot.data![index].price)) ? Colors.green : Colors.red, 
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                  ),
                                ),
                            ),
                            
                          ]),
                      ),
                    );
                  })
                  ),
            );
          }
         }
          return const Center(
            child: Text('Unknown Error')
            );
        }
        ),  
    );
  }
}
