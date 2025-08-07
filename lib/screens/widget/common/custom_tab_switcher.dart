import 'package:flutter/material.dart';

class CustomTabSwitcher extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? selectedTabColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? borderRadius;
  final double? tabBorderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final List<Color>? selectedTabColors;
  final List<Color>? selectedBorderColors;
  final List<Color>? selectedTextColors;

  const CustomTabSwitcher({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = const Color(0xFFF4F4F5),
    this.selectedTabColor = Colors.white,
    this.selectedBorderColor = const Color(0xFFE8E8E8),
    this.selectedTextColor = const Color(0xFF1F2024),
    this.unselectedTextColor = const Color(0xFF71727A),
    this.borderRadius = 12,
    this.tabBorderRadius = 10,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.fontFamily = 'Poppins',
    this.selectedTabColors,
    this.selectedBorderColors,
    this.selectedTextColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            return _buildTab(title, index);
          }).toList(),
        ),
      ),
    );
  }

  Expanded _buildTab(String title, int index) {
    final isSelected = selectedIndex == index;
    
    // Get individual colors for this tab, or fall back to default colors
    final tabColor = isSelected 
        ? (selectedTabColors != null && index < selectedTabColors!.length
            ? selectedTabColors![index]
            : selectedTabColor)
        : Colors.transparent;
        
    final borderColor = isSelected 
        ? (selectedBorderColors != null && index < selectedBorderColors!.length
            ? selectedBorderColors![index]
            : selectedBorderColor)
        : null;
        
    final textColor = isSelected 
        ? (selectedTextColors != null && index < selectedTextColors!.length
            ? selectedTextColors![index]
            : selectedTextColor)
        : unselectedTextColor;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tabColor,
            borderRadius: BorderRadius.circular(tabBorderRadius!),
            border: isSelected && borderColor != null
                ? Border.all(color: borderColor)
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Enhanced tab switcher with swipe functionality
class SwipeableTabSwitcher extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> children;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? selectedTabColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? borderRadius;
  final double? tabBorderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final List<Color>? selectedTabColors;
  final List<Color>? selectedBorderColors;
  final List<Color>? selectedTextColors;

  const SwipeableTabSwitcher({
    Key? key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = const Color(0xFFF4F4F5),
    this.selectedTabColor = Colors.white,
    this.selectedBorderColor = const Color(0xFFE8E8E8),
    this.selectedTextColor = const Color(0xFF1F2024),
    this.unselectedTextColor = const Color(0xFF71727A),
    this.borderRadius = 12,
    this.tabBorderRadius = 10,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.fontFamily = 'Poppins',
    this.selectedTabColors,
    this.selectedBorderColors,
    this.selectedTextColors,
  }) : assert(tabs.length == children.length, 'tabs and children must have the same length'),
       super(key: key);

  @override
  State<SwipeableTabSwitcher> createState() => _SwipeableTabSwitcherState();
}

class _SwipeableTabSwitcherState extends State<SwipeableTabSwitcher>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int selectedTab;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index != selectedTab) {
        setState(() {
          selectedTab = _tabController.index;
        });
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabSwitcher(
          tabs: widget.tabs,
          selectedIndex: selectedTab,
          onTabSelected: (index) {
            if (index != selectedTab) {
              setState(() => selectedTab = index);
              _tabController.animateTo(index);
              widget.onTabChanged?.call(index);
            }
          },
          height: widget.height,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          selectedTabColor: widget.selectedTabColor,
          selectedBorderColor: widget.selectedBorderColor,
          selectedTextColor: widget.selectedTextColor,
          unselectedTextColor: widget.unselectedTextColor,
          borderRadius: widget.borderRadius,
          tabBorderRadius: widget.tabBorderRadius,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: widget.fontFamily,
          selectedTabColors: widget.selectedTabColors,
          selectedBorderColors: widget.selectedBorderColors,
          selectedTextColors: widget.selectedTextColors,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
