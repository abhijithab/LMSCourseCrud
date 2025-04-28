import 'package:flutter/material.dart';
import 'package:re_lms_crud/Models/models.dart';
import 'package:re_lms_crud/Services/lms_service.dart';
import 'package:re_lms_crud/utilities/tokenManager.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  LmsServiceApi service = LmsServiceApi();
  bool isLoading = false;
  int? editCourseId;
  List<courseModel> items = [];
  TextEditingController _courseIdController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _loadItem();
  }

  void _loadItem() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await service.getCourse();
      setState(() {
        items = data;
      });
    } catch (e) {
      throw Exception('error fetching Course:$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearItems() async {
     editCourseId=null;
    _titleController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _endDateController.clear();
  }

  void _createCourse() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;

    try {
      String data = '';
      if (editCourseId != null) {
        data = await service.UpdateCourse(
          editCourseId,
          title,
          description,
          startDate,
          endDate,
        );
      } else {
        data = await service.createCourse(
          title,
          description,
          startDate,
          endDate,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data)));
        Navigator.pop(context);
        _clearItems();
        _loadItem();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data)));
      }
    } catch (e) {
      throw Exception('failed:$e');
    }
  }

  void _deleteCourse(dynamic courseId) async {
    final data = await service.deleteCourse(courseId);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$data')));
      _loadItem();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => homeScreen()),
      // );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error to delete course')));
    }
  }

  void _updateCourse(courseModel course) async {
    editCourseId = course.courseId;

    _titleController.text = course.title.toString();
    _descriptionController.text = course.description ?? '';
    _startDateController.text = course.startDate ?? '';
    _endDateController.text = course.endDate ?? ''; //
    // _startDateController.text=course.startDate!; ANOTHER METHOD
    // _endDateController.text=course.endDate.toString(); ANOTHER METHOD
    _showAddCourseSheet();
  }

  void _showAddCourseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 25,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    editCourseId != null ? 'Update Course' : 'Add New Course',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Title Field
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Description Field
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Start Date Field
                  TextField(
                    controller: _startDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _startDateController.text =
                            picked.toIso8601String().split('T')[0];
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // End Date Field
                  TextField(
                    controller: _endDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _endDateController.text =
                            picked.toIso8601String().split('T')[0];
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      prefixIcon: Icon(Icons.event),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: _createCourse,
                    icon: Icon(
                      editCourseId != null
                          ? Icons.system_update
                          : Icons.save_alt,
                      color: Colors.white,
                    ),
                    label: Text(
                      editCourseId != null ? 'Update Course' : 'Save Course',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
    ).whenComplete(() {
      _clearItems();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        automaticallyImplyLeading: false,
        elevation: 4,
        title: Row(
          children: [
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolix',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LMS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Color(0xFFE3F2FD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Portfolix LMS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.80,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    item.title ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  //SizedBox(height: 5),
                                  Text(
                                    item.description ?? 'No Description',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'ID:${item.courseId.toString()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Divider(),
                                  // Start Date
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        item.startDate?.substring(0, 10) ??
                                            '2025-05-03',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // End Date
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        item.endDate?.substring(0, 10) ??
                                            '2025-05-03',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Divider(),
                                  // Update and Delete Icons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.info_outline),
                                        onPressed: () {},
                                      ),
                                      // Update Icon
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit_note_rounded,
                                          //color: Colors.blueAccent,
                                          //size: 18,
                                        ),
                                        onPressed: () => _updateCourse(item),
                                      ),
                                      // Delete Icon
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever_outlined,
                                          //color: Colors.redAccent,
                                          //size: 18,
                                        ),
                                        onPressed:
                                            () => _deleteCourse(item.courseId),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _showAddCourseSheet,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
