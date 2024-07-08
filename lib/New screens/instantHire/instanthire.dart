import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../../new utils/colors.dart';
import '../../new utils/utils.dart';
import '../../new_services/category_services.dart';
import 'show_nearby_manpower_order_Detail.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

// ignore: must_be_immutable
class InstantHirePage extends StatefulWidget {
  String? category1;
  String? siteLocation;
  int? workHour;
  String? workDetail;
  String lati;
  String longitude;
  InstantHirePage(
      {this.lati = '',
      this.longitude = '',
      this.workHour,
      this.workDetail,
      this.siteLocation,
      this.category1,
      super.key});

  @override
  State<InstantHirePage> createState() => _InstantHirePageState();
}

class _InstantHirePageState extends State<InstantHirePage> {
  TextEditingController _workdetailController = TextEditingController();
  int? _selectedDuration;

  String? selectedCategory;
  List<String> categoryNames = [];
  List<String> categoryprice = [];

  TextEditingController controller = TextEditingController();
  String? lat, long;
  String? place;

  @override
  var orderprice = '';

  String calculatePrice() {
    if (selectedCategory != null && _selectedDuration != null) {
      // Find the index of the selected category in the categoryNames list
      int index = categoryNames.indexOf(selectedCategory!);

      // Extract the price for the selected category from the categoryprice list
      double categoryPricePer8Hour = double.parse(categoryprice[index]);

      // Calculate the total price
      double totalPrice = categoryPricePer8Hour / 8 * _selectedDuration!;

      print('priceeee${totalPrice}');
      return totalPrice.toString();
    }

    return '0'; // Default value if category or duration is not selected
  }

  void initState() {
    super.initState();
    _loadCategories();
    place = widget.siteLocation ?? ' ';
    controller.text = widget.siteLocation ?? '';
    GlobalConstant.instantHirePlace = place!;
    selectedCategory = widget.category1 ?? "Select category";
    GlobalConstant.instantHireCategory = selectedCategory!;
    lat = widget.lati ?? widget.lati;
    long = widget.longitude ?? widget.longitude;
    GlobalConstant.instantHireLat = widget.lati!;
    GlobalConstant.instantHireLong = widget.longitude;
    _selectedDuration = widget.workHour;
    GlobalConstant.instantHireWorkingHrs = _selectedDuration.toString();
    _workdetailController.text = widget.workDetail ?? "";
    GlobalConstant.instantHireWork = _workdetailController.text;
  }

  Future<void> _loadCategories() async {
    await CategoryService.fetchCategories();
    setState(() {
      categoryNames = CategoryService.getCategoryNames();
      categoryprice = CategoryService.getCategoryPrices().cast<String>();
    });
  }

  bool _isDropdownVisible = false;
  List<String> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();
// Assuming categoryprice is a List<String> containing the price for each category
// Assuming _selectedDuration is the number of hours selected
  String? selcatprice;

  @override
  Widget build(BuildContext context) {
    //   place = widget.sitelocation ?? '';
    //   controller.text = widget.sitelocation ?? '';
    //   GlobalConstant.instantHirePlace =place!;
    // selectedCategory = widget.category1;
    // lat = widget.lat;
    // long= widget.long;
    // _selectedDuration= widget.workhrs;
    // _workdetailController.text = widget.workdetail ??"";
    print((widget.category1));
    print(widget.siteLocation);
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Work',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Text(
                'Wave',
                style: SafeGoogleFont('Montserrat',
                    fontSize: mediaQuery.size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan your \nWork",
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff272729),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                placesAutoCompleteTextField(),
                SizedBox(height: mediaQuery.size.height * 0.02),
                Center(
                    child: Row(
                  children: [
                    const Icon(Icons.category_outlined),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle the visibility of the category dropdown
                                _isDropdownVisible = !_isDropdownVisible;
                                if (_isDropdownVisible) {
                                  // Load categories when the container is tapped
                                  _filteredCategories = categoryNames.toList();
                                }
                              });
                            },
                            child: Container(
                              height: mediaQuery.size.height * 0.06,
                              width: mediaQuery.size.width * 0.80,
                              decoration: BoxDecoration(
                                color: AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedCategory ?? 'Select Category',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isDropdownVisible,
                            child: Container(
                              margin: EdgeInsets.only(top: 8),
                              width: mediaQuery.size.width * 0.80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _filteredCategories = categoryNames
                                              .where((category) => category
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search Category',
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        200, // Set the max height of the dropdown list
                                    child: ListView.builder(
                                      itemCount: _filteredCategories.length,
                                      itemBuilder: (context, index) {
                                        final category =
                                            _filteredCategories[index];
                                        return ListTile(
                                          title: Text(category),
                                          onTap: () {
                                            setState(() {
                                              selectedCategory =
                                                  widget.category1 ?? category;
                                              print(
                                                  'select category :${selectedCategory}');
                                              GlobalConstant
                                                      .instantHireCategory =
                                                  selectedCategory.toString();
                                              _isDropdownVisible = false;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
               
                SizedBox(height: mediaQuery.size.height * 0.02),
                Row(
                  children: [
                    const Icon(Icons.timer),
                    Container(
                        height: mediaQuery.size.height * 0.06,
                        width: mediaQuery.size.width * 0.80,
                        decoration: BoxDecoration(
                          color: AppColors.lightgrey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DropdownButtonFormField<int>(
                            hint: const Text('Select Work Duration in Hrs'),
                            value: _selectedDuration,
                            onChanged: (value) {
                              setState(() {
                                _selectedDuration = value;
                                GlobalConstant.instantHireWorkingHrs =
                                    value.toString();
                              });
                            },
                            items: List.generate(8, (index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              );
                            }),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )))
                  ],
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                Row(
                  children: [
                    const Icon(Icons.date_range),
                    Container(
                        height: mediaQuery.size.height * 0.10,
                        width: mediaQuery.size.width * 0.80,
                        decoration: BoxDecoration(
                          color: AppColors.lightgrey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextField(
  onChanged: (value) {
    setState(() {
      GlobalConstant.instantHireWork = value;
    });
  },
  controller: _workdetailController,
  inputFormatters: [
    LengthLimitingTextInputFormatter(150), // Limit the input to 150 characters
  ],
  decoration: const InputDecoration(
    hintText: 'Work Detail',
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
  ),
)

                        )))
                  ],
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        //                            double totalValue = calculatePrice();
                        // print('Total Value: $totalValue');
                        // GlobalConstant.instantprice = totalValue.toStringAsFixed(2);

                        if (GlobalConstant.instantHireCategory != "" &&
                            GlobalConstant.instantHireWorkingHrs != "" &&
                            GlobalConstant.instantHireWork != "" &&
                            GlobalConstant.instantHireLat != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManpowerNearBy(
                                        lat: lat,
                                        long: long,
                                        sitelocation: place,
                                        duration: _selectedDuration,
                                        category: widget.category1 ??
                                            selectedCategory,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                "Please select all Parameters",
                                style: TextStyle(color: Colors.white),
                              )));
                        }
                      },
                      child: Container(
                        height: mediaQuery.size.height * 0.06,
                        width: mediaQuery.size.width * 0.60,
                        decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            'Search Manpower',
                            style: SafeGoogleFont(
                              'Montserrat',
                              fontSize: mediaQuery.size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    var mediaQuery = MediaQuery.of(context);
    return Row(
      children: [
        Icon(Icons.location_on),
        Container(
          height: mediaQuery.size.height * 0.06,
          width: mediaQuery.size.width * 0.80,
          color: AppColors.lightgrey,

 child: GestureDetector(
  onTap: () {
    FocusScope.of(context).requestFocus(FocusNode());
  },
   child: GooglePlaceAutoCompleteTextField(
    
    
    textEditingController: controller,
    
    googleAPIKey: "AIzaSyDPqZ0_gzMHgTKMc9l6F_VKZOpaX4eytkE",
    inputDecoration: InputDecoration(
      
      hintText: "Work location",
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
    ),
    debounceTime: 400,
    countries: ["in", "us"],
    isLatLngRequired: true,
    getPlaceDetailWithLatLng: (Prediction prediction) {
      
      if (prediction != null) {
        setState(() {
          lat = prediction.lat;
          long = prediction.lng;
          place = prediction.description ?? "";
          controller.text = place!; // Update controller text
          GlobalConstant.instantHireLat = lat ?? "";
          GlobalConstant.instantHireLong = long ?? "";
          GlobalConstant.instantHirePlace = place ?? ""; 
        });
        print("lat: $lat, long: $long");
      }
    },
    itemClick: (Prediction prediction) {
      if (prediction != null && prediction.description != null) {
        controller.text = prediction.description!;
      }
    },
    seperatedBuilder: Divider(),
    containerHorizontalPadding: 10,
    itemBuilder: (context, index, Prediction prediction) {
      return Container(
        height: mediaQuery.size.height * 0.07,
        width: mediaQuery.size.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(child: Text("${prediction.description ?? ""}"))
          ],
        ),
      );
      
    },
   
    isCrossBtnShown: true,
    
   ),
 ),

        ),
      ],
    );
  }
}
