import 'package:flutter/material.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/category_services.dart';
import '../../instantHire/instanthire.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}
  
class _CategoryListState extends State<CategoryList> {

  
@override
  void initState() {
   
    super.initState();
   
     loadCategories();
  }
    List<String> categoryNames = [];
  List<String> categoryid = [];
   List<String> categoryimage = [];

   Future<void> loadCategories() async {
    await CategoryService.fetchCategories();
    setState(() {
      categoryNames = CategoryService.getCategoryNames();
      categoryid =CategoryService.getCategoryId();
    // categoryimage =CategoryService.getCategoryimages().cast<String>();
    });
  }
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: Text('Category', style: SafeGoogleFont(
                        'Nunito',
                        fontSize: mediaQuery.size.width * 0.05,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.82,
          child: ListView.builder(
            itemCount: CategoryService.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Container(
                      decoration: BoxDecoration(
                       // color: Colors.black,
                       border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                      height: MediaQuery.of(context).size.height*0.1,
                      child: Center(
                        child: GestureDetector(
                          onTap: (() {
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  InstantHirePage(category1: CategoryService.categories[index].name ,)));
                          }),
                          child: ListTile(
                            
                            
                          
                           
                            // leading:Image.network(
                            //       CategoryService.categories[index].image,
                            //       scale: MediaQuery.of(context).size.width * 0.017,
                            //     ),
                                trailing: Text(
                            CategoryService.categories[index].name,
                           style: SafeGoogleFont(
                                            'Montserrat',
                                            fontSize: mediaQuery.size.width * 0.03,
                                            fontWeight: FontWeight.w500,
                                            height: 1.2175,
                                            color: const Color(0xff222222),
                                          ),
                          ) ,
                          ),
                        ),
                      ),
                    ),
                   
                    
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


