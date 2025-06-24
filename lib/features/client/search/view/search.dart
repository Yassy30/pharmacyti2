// import 'package:flutter/material.dart';
// import 'package:pharmaciyti/features/client/cart/viewmodel/cart_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:pharmaciyti/features/client/search/viewmodel/search_viewmodel.dart';
// import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

// class SearchPage extends StatefulWidget {
//   final String initialQuery;

//   const SearchPage({Key? key, this.initialQuery = ''}) : super(key: key);

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.initialQuery);
//     // Initialize search with initial query
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<SearchViewModel>(context, listen: false)
//           .updateSearchQuery(widget.initialQuery);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final viewModel = Provider.of<SearchViewModel>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.04,
//                 vertical: screenHeight * 0.02,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: screenHeight * 0.07,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(color: Colors.grey[300]!, width: 1.5),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 6,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//                             child: Icon(Icons.search, color: Colors.grey[600], size: screenWidth * 0.07),
//                           ),
//                           Expanded(
//                             child: TextField(
//                               controller: _controller,
//                               onChanged: (value) {
//                                 viewModel.updateSearchQuery(value);
//                               },
//                               decoration: InputDecoration(
//                                 hintText: "Search for medicines, pharmacies...",
//                                 hintStyle: TextStyle(color: Colors.grey[500]),
//                                 border: InputBorder.none,
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
//                               ),
//                               style: TextStyle(fontSize: screenWidth * 0.045),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.03),
//                   Container(
//                     height: screenHeight * 0.07,
//                     width: screenHeight * 0.07,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.grey[300]!, width: 1.5),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       icon: Icon(Icons.tune, color: Colors.grey[700], size: screenWidth * 0.07),
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Advanced filter options not implemented yet')),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.04,
//                 vertical: screenHeight * 0.02,
//               ),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildFilterButton("Prescription", screenWidth, viewModel),
//                     SizedBox(width: screenWidth * 0.025),
//                     _buildFilterButton("Distance", screenWidth, viewModel),
//                     SizedBox(width: screenWidth * 0.025),
//                     _buildFilterButton("Price", screenWidth, viewModel),
//                     SizedBox(width: screenWidth * 0.025),
//                     _buildFilterButton("Rating", screenWidth, viewModel),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: viewModel.isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : viewModel.errorMessage != null
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 viewModel.errorMessage!,
//                                 style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.red),
//                               ),
//                               TextButton(
//                                 onPressed: () => viewModel.fetchMedicines(),
//                                 child: Text('Retry'),
//                               ),
//                             ],
//                           ),
//                         )
//                       : viewModel.medicines.isEmpty
//                           ? _buildNoResultsFound(screenWidth, screenHeight, viewModel.searchQuery, viewModel.selectedFilter)
//                           : ListView.builder(
//                               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                               itemCount: viewModel.medicines.length,
//                               itemBuilder: (context, index) {
//                                 final medicine = viewModel.medicines[index];
//                                 return _buildMedicineItem(medicine, screenWidth, screenHeight);
//                               },
//                             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterButton(String label, double screenWidth, SearchViewModel viewModel) {
//     bool isSelected = viewModel.selectedFilter == label;
//     return GestureDetector(
//       onTap: () {
//         viewModel.updateFilter(isSelected ? null : label);
//       },
//       child: Container(
//         height: screenWidth * 0.12,
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue[50] : Colors.white,
//           border: Border.all(
//               color: isSelected ? Colors.blue[700]! : Colors.grey[300]!, width: 1.5),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 color: isSelected ? Colors.blue[700] : Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(width: screenWidth * 0.015),
//             Icon(
//               Icons.keyboard_arrow_down,
//               size: screenWidth * 0.055,
//               color: isSelected ? Colors.blue[700] : Colors.grey[600],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNoResultsFound(double screenWidth, double screenHeight, String searchQuery, String? selectedFilter) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: screenWidth * 0.5,
//             height: screenHeight * 0.3,
//             child: Image.asset('assets/images/notFound.png'),
//           ),
//           SizedBox(height: screenHeight * 0.02),
//           Text(
//             searchQuery.isNotEmpty || selectedFilter != null
//                 ? 'No medicine found for "${searchQuery.isNotEmpty ? searchQuery : selectedFilter}".'
//                 : 'Enter a search term or select a filter',
//             style: TextStyle(
//               fontSize: screenWidth * 0.05,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           Text(
//             'Try checking the spelling or filters.',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicineItem(Medicine medicine, double screenWidth, double screenHeight) {
//     return Container(
//       margin: EdgeInsets.only(bottom: screenHeight * 0.02),
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: screenWidth * 0.2,
//             height: screenWidth * 0.2,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: medicine.image != null
//                 ? Image.network(
//                     medicine.image!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Icon(
//                       Icons.medication,
//                       size: screenWidth * 0.1,
//                       color: Colors.grey[600],
//                     ),
//                   )
//                 : Icon(
//                     Icons.medication,
//                     size: screenWidth * 0.1,
//                     color: Colors.grey[600],
//                   ),
//           ),
//           SizedBox(width: screenWidth * 0.04),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   medicine.name,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.005),
//                 Text(
//                   '\$${medicine.price.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.04,
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.005),
//                 if (medicine.statusPrescription)
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth * 0.02,
//                       vertical: screenHeight * 0.005,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       'Prescription Required',
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.035,
//                         color: Colors.blue[700],
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: screenHeight * 0.005),
//                 Text(
//                   'In stock: ${medicine.quantity}',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.add_shopping_cart, color: Colors.blue[700], size: screenWidth * 0.07),
//             onPressed: () {
//               final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
//               cartViewModel.addToCart(
//                 medicine,
//                 'Pharmacy Al Baraka', // You should replace this with actual pharmacy data
//                 '1.2 km', // You should replace this with actual distance calculation
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Added ${medicine.name} to cart')),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/client/cart/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/client/search/viewmodel/search_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({Key? key, this.initialQuery = ''}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchViewModel>(context, listen: false)
          .updateSearchQuery(widget.initialQuery);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<SearchViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            child: Icon(Icons.search, color: Colors.grey[600], size: screenWidth * 0.07),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) {
                                viewModel.updateSearchQuery(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search for medicines, pharmacies...",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                              ),
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Container(
                    height: screenHeight * 0.07,
                    width: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: Colors.grey[700], size: screenWidth * 0.07),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Advanced filter options not implemented yet')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton("Prescription", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Distance", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Price", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Rating", screenWidth, viewModel),
                  ],
                ),
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                viewModel.errorMessage!,
                                style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.red),
                              ),
                              TextButton(
                                onPressed: () => viewModel.fetchMedicines(),
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : viewModel.medicines.isEmpty
                          ? _buildNoResultsFound(screenWidth, screenHeight, viewModel.searchQuery, viewModel.selectedFilter)
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                              itemCount: viewModel.medicines.length,
                              itemBuilder: (context, index) {
                                final medicine = viewModel.medicines[index];
                                return _buildMedicineItem(medicine, screenWidth, screenHeight, cartViewModel);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, double screenWidth, SearchViewModel viewModel) {
    bool isSelected = viewModel.selectedFilter == label;
    return GestureDetector(
      onTap: () {
        viewModel.updateFilter(isSelected ? null : label);
      },
      child: Container(
        height: screenWidth * 0.12,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: screenWidth * 0.015),
            Icon(
              Icons.keyboard_arrow_down,
              size: screenWidth * 0.055,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsFound(double screenWidth, double screenHeight, String searchQuery, String? selectedFilter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.5,
            height: screenHeight * 0.3,
            child: Image.asset('assets/images/notFound.png'),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            searchQuery.isNotEmpty || selectedFilter != null
                ? 'No medicine found for "${searchQuery.isNotEmpty ? searchQuery : selectedFilter}".'
                : 'Enter a search term or select a filter',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Try checking the spelling or filters.',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(Medicine medicine, double screenWidth, double screenHeight, CartViewModel cartViewModel) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: medicine.image != null
                ? Image.network(
                    medicine.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.medication,
                      size: screenWidth * 0.1,
                      color: Colors.grey[600],
                    ),
                  )
                : Icon(
                    Icons.medication,
                    size: screenWidth * 0.1,
                    color: Colors.grey[600],
                  ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '\$${medicine.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                if (medicine.statusPrescription)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Prescription Required',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'In stock: ${medicine.quantity}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Colors.blue[700], size: screenWidth * 0.07),
            onPressed: () {
              cartViewModel.addToCart(medicine);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${medicine.name} to cart')),
              );
            },
          ),
        ],
      ),
    );
  }
}