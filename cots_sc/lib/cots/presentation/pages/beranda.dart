import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart'; 
import '../../controllers/task_controller.dart';

import 'tambah_tugas.dart'; 
import 'daftar_tugas.dart'; 
import 'detail_tugas.dart'; 

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tugas Besar", style: AppTextStyles.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const DaftarTugasPage())
              );
            },
            child: const Text("Daftar Tugas", style: TextStyle(color: AppColors.primaryBlue)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppLayout.cardPadding), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSummaryCard("Total Tugas", "${taskController.totalTasks}"),
                const SizedBox(width: AppLayout.mediumSpacing),
                _buildSummaryCard("Selesai", "${taskController.completedTasks}"),
              ],
            ),
            const SizedBox(height: AppLayout.largeSpacing),
            
            const Text("Tugas Terdekat", style: AppTextStyles.section),
            const SizedBox(height: AppLayout.cardRadius),

            // List Tugas Mepet Dedlen
            Expanded(
              child: ListView.builder( 
                itemCount: taskController.tasks.length > 3 ? 3 : taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppLayout.smallSpacing),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                        side: BorderSide(color: AppColors.border) 
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppLayout.cardPadding),                
                      title: Text(task.title, style: AppTextStyles.section),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(task.course, style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(
                            "Deadline: ${DateFormat('d MMM yyyy').format(task.deadline)}", 
                            style: AppTextStyles.caption.copyWith(color: AppColors.errorRed)
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: task.isDone 
                            ? Colors.green.withOpacity(0.2) 
                            : AppColors.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          task.isDone ? "Selesai" : "Berjalan",
                          style: TextStyle(
                            color: task.isDone ? Colors.green : AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailTugasPage(taskId: task.id))
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppLayout.cardPadding),
        child: SizedBox(
          height: AppLayout.elementHeight, 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppLayout.cardRadius)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahTugasPage()),
              );
            },
            child: const Text("Tambah Tugas", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppLayout.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 4, 
              offset: const Offset(0, 2)
            )
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.body),
            const SizedBox(height: 8),
            Text(count, style: AppTextStyles.title),
          ],
        ),
      ),
    );
  }
}