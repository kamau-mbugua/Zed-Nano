import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/logger.dart';

class LocationPickerField extends StatefulWidget {
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextEditingController controller;
  final void Function(String)? onLocationSelected;
  final String label;
  final String apiKey;
  final List<String> countries;
  final double debounceTime;
  final int minInputLength;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double height;

  const LocationPickerField({
    Key? key,
    required this.controller,
    this.apiKey = 'AIzaSyA1i-fE9PcTl1dvC06vhpy7AR_C6c90lTU',
    this.focusNode,
    this.nextFocus,
    this.label = 'Location',
    this.countries = const ['ke', 'ug', 'tz'],
    this.debounceTime = 200,
    this.minInputLength = 2,
    this.onLocationSelected,
    this.textStyle,
    this.labelStyle,
    this.height = 48,
  }) : super(key: key);

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<PlacePrediction> _predictions = [];
  Timer? _debounceTimer;
  bool _isLoading = false;
  bool _isSettingTextProgrammatically = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Skip search if we're setting text programmatically
    if (_isSettingTextProgrammatically) {
      return;
    }
    
    final text = widget.controller.text;
    print('LocationPickerField: Text changed to: "$text"'); // Debug log
    
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceTime.toInt()), () {
      print('LocationPickerField: Debounced search for: "$text"'); // Debug log
      if (text.length >= widget.minInputLength) {
        _searchPlaces(text);
      } else {
        _removeOverlay();
      }
    });
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(input)}'
          '&key=${widget.apiKey}'
          '&components=${widget.countries.map((c) => 'country:$c').join('|')}';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final predictionsData = data['predictions'] as List<dynamic>?;
        
        if (predictionsData != null) {
          final predictions = predictionsData
              .cast<Map<String, dynamic>>()
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
          
          setState(() {
            _predictions = predictions;
            _isLoading = false;
          });
          
          _showOverlay();
        } else {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      loggerNoStack.e('Error searching places: $e');
      setState(() {
        _isLoading = false;
        _predictions = [];
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    
    if (_predictions.isEmpty) return;
    
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return InkWell(
                    onTap: () => _onPredictionSelected(prediction),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: index < _predictions.length - 1
                            ? Border(bottom: BorderSide(color: Colors.grey.shade200))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prediction.description,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xff2f3036),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPredictionSelected(PlacePrediction prediction) {
    // Set flag to prevent triggering search when setting text
    _isSettingTextProgrammatically = true;
    
    widget.controller.text = prediction.description;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: prediction.description.length),
    );
    
    // Reset flag after setting text
    _isSettingTextProgrammatically = false;
    
    // Clear predictions and close overlay
    setState(() {
      _predictions = [];
    });
    
    widget.onLocationSelected?.call(prediction.description);
    _removeOverlay();
    
    // Handle focus navigation
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: BodyWhite),
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
        ),
        child: AppTextField(
          controller: widget.controller,
          focus: widget.focusNode,
          textFieldType: TextFieldType.OTHER,
          enabled: true,
          readOnly: false,
          onChanged: (value) {
            print('LocationPickerField: onChanged called with: "$value"'); // Debug log
            // This will trigger _onTextChanged through the controller listener
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: widget.label,
            hintStyle: const TextStyle(
              color: Color(0xff8f9098),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontSize: 14.0,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff8f9098),
                        ),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xff8f9098),
                    size: 20,
                  ),
          ),
          onFieldSubmitted: (value) {
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            }
          },
        ),
      ),
    );
  }
}

class PlacePrediction {
  final String placeId;
  final String description;

  PlacePrediction({
    required this.placeId,
    required this.description,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
