import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import 'tambah_tugas.dart';
import 'detail_tugas.dart'; 

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  String _searchQuery = "";
  String _selectedFilter = "Semua"; 

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    
    // Filter Lokal (Data sudah diambil di Beranda)
    List<Task> filteredTasks = taskController.tasks.where((task) {
      // Filter Search 
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            task.course.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesFilter = true;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      if (_selectedFilter == "Selesai") {
        matchesFilter = task.isDone;
      } else if (_selectedFilter == "Berjalan") {
        matchesFilter = !task.isDone && task.deadline.isAfter(today.subtract(const Duration(days: 1)));
      } else if (_selectedFilter == "Terlambat") {
        matchesFilter = !task.isDone && task.deadline.isBefore(today);
      }

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Daftar Tugas", style: AppTextStyles.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlue),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.primaryBlue),
            ),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahTugasPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: taskController.isLoading 
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          const SizedBox(height: AppLayout.smallSpacing),
          
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppLayout.cardPadding),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Cari tugas atau mata kuliah...",
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.elementHeight / 2), 
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.elementHeight / 2),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppLayout.mediumSpacing),

          // FILTER CHIPS 
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppLayout.cardPadding),
            child: Row(
              children: ["Semua", "Berjalan", "Selesai", "Terlambat"].map((filter) {
                final isActive = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      filter, 
                      style: isActive 
                        ? AppTextStyles.button.copyWith(color: Colors.white)
                        : AppTextStyles.body.copyWith(color: AppColors.textMuted),
                    ),
                    selected: isActive,
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isActive ? AppColors.primaryBlue : AppColors.border
                      )
                    ),
                    onSelected: (bool selected) {
                      if (selected) setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppLayout.mediumSpacing),

          // LIST TUGAS 
          Expanded(
            child: filteredTasks.isEmpty 
            ? Center(child: Text("Tidak ada tugas ditemukan", style: AppTextStyles.caption))
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.cardPadding),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return _buildTaskItem(task, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item Tugas
  Widget _buildTaskItem(Task task, BuildContext context) {
    // Menentukan Warna Status
    Color statusColor = AppColors.primaryBlue;
    if (task.isDone) {
      statusColor = Colors.green; 
    } else if (task.deadline.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      statusColor = AppColors.errorRed; 
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppLayout.mediumSpacing),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppLayout.cardPadding),
        onTap: () {
          // Navigasi ke Detail Tugas (Pastikan ID tidak null)
           if (task.id != null) {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => DetailTugasPage(taskId: task.id!)),
             );
           }
        },
        leading: Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 4), 
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(task.title, style: AppTextStyles.section), 
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(task.course, style: AppTextStyles.caption),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('d MMM').format(task.deadline), 
              style: AppTextStyles.caption.copyWith(
                color: statusColor == AppColors.errorRed ? AppColors.errorRed : AppColors.textMuted
              )
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}