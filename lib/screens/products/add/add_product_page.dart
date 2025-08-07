import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/getVariablePriceStatus/GetVariablePriceStatusResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/unitofmeasure/UnitOfMeasureResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';


class AddProductScreen extends StatefulWidget {
  final bool doNotUpdate;
  final String? selectedCategory;
  final String? productService;
  
  const AddProductScreen({
    super.key, 
    required this.doNotUpdate,
    this.selectedCategory,
    this.productService,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  FocusNode productNameFocusNode = FocusNode();
  FocusNode productAmountFocusNode = FocusNode();
  FocusNode productRestockFocusNode = FocusNode();
  FocusNode productDescriptionFocusNode = FocusNode();
  FocusNode buyingPriceFocusNode = FocusNode();

  TextEditingController productNameController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  TextEditingController productAmountController = TextEditingController();
  TextEditingController productRestockController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedProductService;
  String? selectedUnitOfMeasure;
  String? selectedPriceStatus;
  bool isWeightedProduct = false;
  List<ProductCategoryData>? productCategoryDataList;
  List<String>? unitOfMeasureResponse;
  List<VariablePriceStatus>? variablePriceStatus;

  File? _logoImage;

  BusinessDetails? businessDetails;



  Future<void> _pickImage() async {
    final pickedImage = await ImagePickerUtil.pickImage(
      context: context,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _logoImage = pickedImage;
      });
    }
  }


  Future<void> refresh() async {
    try {
      final viewModel = Provider.of<WorkflowViewModel>(context, listen: false);
      await viewModel.skipSetup(context);

      if (mounted) {
        Navigator.pop(context); // Pop current screen
        await Navigator.pushNamed(context, AppRoutes.getListProductsAndServicesRoute());
      }

    } catch (e) {
      logger.e('Error in refresh: $e');
    }
  }

  Future<void> _createCategory(Map<String, dynamic> requestData) async {
    requestData['doNotUpdate'] = widget.doNotUpdate;
    await context
        .read<BusinessProviders>()
        .createProduct(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Product created successfully',
            isError: false);
        if (_logoImage != null) {
          _uploadBusinessLogo(value.data?.productId);
        } else {
          // Check if we were called from CategoryDetailPage (if selectedCategory is set)
          if (widget.selectedCategory != null) {
            // Just pop back to the category detail page
            Navigator.pop(context, true); // Pass true to indicate successful creation
          } else {
            // Otherwise do full refresh
            refresh();
          }
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _uploadBusinessLogo(String? serviceId) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _logoImage!.path,
        filename: p.basename(_logoImage!.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
      'businessNumber': businessDetails?.businessNumber
    });

    final urlPart = '?serviceId=$serviceId';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData!, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Image uploaded successfully',
            isError: false);
            
        // Check if we were called from CategoryDetailPage (if selectedCategory is set)
        if (widget.selectedCategory != null) {
          // Just pop back to the category detail page
          Navigator.pop(context, true); // Pass true to indicate successful creation
        } else {
          // Otherwise do full refresh
          refresh();
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }


  @override
  void initState() {
    businessDetails = getBusinessDetails(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await listBusinessCategory();
      await getUnitOfMeasure();
      await getVariablePriceStatus();
      
      // Set initial category if provided from navigation
      if (widget.selectedCategory != null && mounted) {
        setState(() {
          selectedCategory = widget.selectedCategory;
        });
      }
    });
    super.initState();
  }

  Future<void> listBusinessCategory() async {
    final productService = widget.productService; // Use passed productService if available
    
    await context
        .read<BusinessProviders>()
        .getListCategories(
            context: context, 
            page: 1, 
            limit: 10000, 
            searchValue: '', 
            productService: productService ?? '')
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          productCategoryDataList = value.data!.data;
          
          // If we have a selectedCategory from the arguments, validate it exists in the loaded categories
          if (widget.selectedCategory != null) {
            final categoryExists = productCategoryDataList?.any(
                (category) => category.categoryName == widget.selectedCategory) ?? false;
                
            if (categoryExists) {
              selectedCategory = widget.selectedCategory;
            }
          }
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> getUnitOfMeasure() async {
    await context
        .read<BusinessProviders>()
        .getUnitOfMeasure(context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          unitOfMeasureResponse = value.data!.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> getVariablePriceStatus() async {
    await context
        .read<BusinessProviders>()
        .getVariablePriceStatus(context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          variablePriceStatus = value.data!.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    productAmountController.dispose();
    productRestockController.dispose();
    productDescriptionController.dispose();

    productNameFocusNode.dispose();
    productAmountFocusNode.dispose();
    productRestockFocusNode.dispose();
    productDescriptionFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(title: 'Add Product or Service'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            // Category Name
            headings(
              label: selectedProductService?.toLowerCase() != 'service' ? 'New Product' : 'New Service',
              subLabel: selectedProductService?.toLowerCase() != 'service' ? 'Enter product details.' : 'Enter service details.',
            ),
            _formFields(),
            _uploadImage(),
            const SizedBox(height: 32),
            appButton(
              text:  selectedProductService?.toLowerCase() != 'service' ? 'New Product' : 'New Service',
              context: context,
              onTap: () {
                var categoryId = selectedCategory;
                var prodctName = productNameController.text;
                var productAmount = productAmountController.text;
                var productRestock = productRestockController.text;
                var productDescription = productDescriptionController.text;
                var productService =  selectedProductService;
                var unitOfMeasure =  selectedUnitOfMeasure;
                var priceStatus =  selectedPriceStatus;
                var buyingPrice =  buyingPriceController.text;

                if(categoryId == null){
                  showCustomToast('Please select category', isError: true);
                  return;
                }
                if(productService == null){
                  showCustomToast('Please select category', isError: true);
                  return;
                }
                if(!prodctName.isValidInput){
                  showCustomToast('Please enter product name', isError: true);
                  return;
                }
                if(!productAmount.isValidInput){
                  showCustomToast('Please enter product selling price amount', isError: true);
                  return;
                }
                if(!buyingPrice.isValidInput && selectedProductService?.toLowerCase() != 'service'){
                  showCustomToast('Please enter product buying price amount', isError: true);
                  return;
                }
                if(unitOfMeasure == null && selectedProductService?.toLowerCase() != 'service'){
                  showCustomToast('Select unit of measure', isError: true);
                  return;
                }
                if(priceStatus == null){
                  showCustomToast('Select price status', isError: true);
                  return;
                }

                var requestData = <String, dynamic>{};
                requestData['productCategory'] = categoryId;
                requestData['productName'] = prodctName;
                requestData['productPrice'] = productAmount;
                requestData['productRestock'] = productRestock;
                requestData['productDescription'] = productDescription;
                requestData['productService'] = productService;
                requestData['buyingPrice'] = buyingPrice;
                requestData['priceStatus'] = priceStatus;
                requestData['unitOfMeasure'] = unitOfMeasure;
                requestData['isWeightedProduct'] = isWeightedProduct;
                requestData['consumable'] = false;

                _createCategory(requestData);

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF484848),
          ),
        ),
        const SizedBox(height: 8),
        SubCategoryPicker(
          label: 'Select Category',
          options: productCategoryDataList?.map((e) => e.categoryName ?? '').toList() ?? [],
          selectedValue: selectedCategory,
          onChanged: (value) {
            final selectedCat = value;
            setState(() {
              selectedCategory = selectedCat;
              selectedProductService = productCategoryDataList?.firstWhere((element) => element.categoryName == selectedCategory).productService;
            });
          },
        ),
        16.height,
        // Product Name
        const Text(
          'Product Name',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF484848),
          ),
        ),
        const SizedBox(height: 8),
        StyledTextField(
          textFieldType: TextFieldType.NAME,
          hintText: 'Product Name',
          focusNode: productNameFocusNode,
          nextFocus: productDescriptionFocusNode,
          controller: productNameController,
        ),
        16.height,

        // Description
        const Row(
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF1F2024),
              ),
            ),
            SizedBox(width: 8),
            Text(
              '(Optional)',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF8F90A6),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
          StyledTextField(
          textFieldType: TextFieldType.MULTILINE,
          hintText: 'Description',
          focusNode: productDescriptionFocusNode,
          controller: productDescriptionController,
            nextFocus: productAmountFocusNode,
        ),
        16.height,
        Visibility(
          visible: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Price Type',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF484848),
                ),
              ),
              const SizedBox(height: 8),
              SubCategoryPicker(
                label: 'Select Price Type',
                options:variablePriceStatus?.map((e) => e.priceStatusName ?? '').toList() ??
                    [],
                selectedValue: selectedPriceStatus,
                onChanged: (value) {
                  final selectedCat = value;
                  setState(() {
                    selectedPriceStatus = selectedCat;
                  });
                },
              ),
            ],
          ),
        ),
        16.height,
        if ((selectedPriceStatus?.toLowerCase().contains('variable') ?? false)
            && (selectedProductService?.toLowerCase() != 'service')) ...[
          16.height,
          const Text(
            'Weighted product',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: isWeightedProduct,
                onChanged: (checked) {
                  setState(() {
                    isWeightedProduct = checked ?? false;
                  });
                },
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("This is weighted product."),
                    Text(
                      "Product price will adjust based on weight when sold.",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
        16.height,
        selectedProductService?.toLowerCase() != 'service' ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unit of Measure',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            SubCategoryPicker(
              label: 'Select Unit of Measure',
              options:unitOfMeasureResponse?.map((e) => e ?? '').toList() ?? [],
              selectedValue: selectedUnitOfMeasure,
              onChanged: (value) {
                final selectedCat = value;
                setState(() {
                  selectedUnitOfMeasure = selectedCat;
                });
              },
            ),

            const Text(
              'Selling Price',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: 'Selling Price',
              focusNode: productAmountFocusNode,
              nextFocus: buyingPriceFocusNode,
              controller: productAmountController,
            ),
            16.height,

            const Text(
              'Buying Price',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: 'Buying Price',
              focusNode: buyingPriceFocusNode,
              nextFocus: productRestockFocusNode,
              controller: buyingPriceController,
            ),
            16.height,
            const Row(
              children: [
                Text(
                  'Restock Level',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1F2024),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8F90A6),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: 'Restock Level',
              focusNode: productRestockFocusNode,
              nextFocus: productDescriptionFocusNode,
              controller: productRestockController,
            ),
            4.height,
            const Text(
              'Get notified when stock is below this value.',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Poppins',
                color: Color(0xFFB5B7C0),
              ),
            ),
          ],
        ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF484848),
                  ),
                ),
                const SizedBox(height: 8),
                StyledTextField(
                  textFieldType: TextFieldType.NAME,
                  hintText: 'Price',
                  focusNode: productAmountFocusNode,
                  nextFocus: buyingPriceFocusNode,
                  controller: productAmountController,
                ),
                16.height,
              ],
            ),


        const SizedBox(height: 24),
      ]);
  }
  Widget _uploadImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(16),
            ),
            child:_logoImage != null ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _logoImage!,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ) :  const Icon(Icons.image,
                size: 28, color: Color(0xFF8A8D9F)),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Add Image',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2024),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2024),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Select an image from your gallery or take a photo.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Color(0xFF8A8D9F),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
