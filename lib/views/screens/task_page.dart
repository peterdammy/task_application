import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/provider/task_provider.dart';
import 'package:task_app/views/screens/add_task_page.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Task Page',
            style: GoogleFonts.play(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 5.0,
        ),
        body:
            tasks.isEmpty
                ? Center(
                  child: Text(
                    "No tasks available",
                    style: GoogleFonts.play(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (contxt, index) => 10.verticalSpace,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      child: Dismissible(
                        key: ValueKey(task.taskId),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20.w),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.amber,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          child: Icon(Icons.star, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            ref
                                .read(taskListProvider.notifier)
                                .deleteTask(task.taskId);
                            return true;
                          } else {
                            ref
                                .read(taskListProvider.notifier)
                                .toggleFavorite(task.taskId);
                            return false;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.taskName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(task.taskDescription),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    "Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
                                  ),
                                  Spacer(),
                                  if (task.isFavorite)
                                    Icon(Icons.star, color: Colors.amber),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              ),
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
