import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/database/course.dart';
import '../../app/database/database_helper.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  List<CourseContent> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    final contents = await DatabaseHelper.instance.getContentsForCourse(widget.course.id!);
    setState(() {
      _contents = contents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        title: Text(widget.course.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contents.isEmpty
              ? const Center(child: Text('No contents available.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: _contents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final content = _contents[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            content.body,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white50,
                                  height: 1.6,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
