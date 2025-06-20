import 'package:flutter/material.dart';
import 'package:matchupnews/views/utils/helper.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? selectedCategory;

  final List<String> categories = ['Politics', 'Technology', 'Health', 'Sports'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      appBar: AppBar(
        backgroundColor: cBgDc,
        elevation: 0,
        leading: BackButton(color: cPrimary),
        title: Text(
          'Create New News', style: headline4.copyWith(color: cWhite, fontWeight: bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Cover Photo Placeholder
                GestureDetector(
                  onTap: () {
                    // Nanti buat sistem picker gambar
                  },
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cBoxDc,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: cPrimary),
                        SizedBox(height: 8),
                        Text(
                          'Add Cover Photos',
                          style: subtitle1.copyWith(color: cWhite),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),
                Text(
                  'News Details',
                  style: subtitle2.copyWith(color: cWhite,fontWeight: bold),
                ),
                SizedBox(height: 12),

                // Title Field
                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration('Title'),
                  style: TextStyle(color: cWhite),
                ),
                SizedBox(height: 12),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: TextStyle(color: cWhite)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  dropdownColor: cBoxDc,
                  iconEnabledColor: cWhite,
                  decoration: _inputDecoration('Category'),
                  style: TextStyle(decorationColor: cWhite),
                ),
                SizedBox(height: 12),
              
                // Content Field
                TextFormField(
                  controller: contentController,
                  decoration: _inputDecoration('Content'),
                  style: TextStyle(color: cWhite),
                  maxLines: 6,
                ),

                SizedBox(height: 24),

                // Publish Button
                ElevatedButton(
                  onPressed: () {
                    // Nanti ditambah sistem tambah berita
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Publish Now',
                    style: subtitle1.copyWith(color: cWhite, fontWeight: bold),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cWhite),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
