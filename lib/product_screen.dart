import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/data/products.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    super.key,
    required this.id,
    });

    final int id; 


  Future<Product?> getProduct() async{
    await Future.delayed(const Duration(seconds: 1));
    return products.firstWhere((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
              centerTitle: true, 
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {

          if(snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(snapshot.error.toString()),
              ),
              body: Center(
              child: Text(snapshot.error.toString())
            )
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(snapshot.data!.title),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.network(snapshot.data!.photo),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          child: Text(
                            snapshot.data!.description,
                            textAlign: TextAlign.justify, 
                            style: const TextStyle(
                              color: Color.fromARGB(198, 31, 30, 30),
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${snapshot.data!.price.ceil().toString()}₽',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: (){},
                            child: const Text('В корзину')
                        )
                      ]
                    ),
                )),
            );
          }

        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ошибка при загрузке товара'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('Unknown Error'),
          ),
        );
      });
  }
}