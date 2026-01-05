import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/task_controller.dart';

class DetailTugasPage extends StatefulWidget {
  final int? taskId; 

  const DetailTugasPage({super.key, required this.taskId});

  @override
  State<DetailTugasPage> createState() => _DetailTugasPageState();
}

class _DetailTugasPageState extends State<DetailTugasPage> {
  late bool _isDone;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final task = Provider.of<TaskController>(context, listen: false)
          .tasks.firstWhere((t) => t.id == widget.taskId);
      _isDone = task.isDone;
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final task = taskController.tasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => throw Exception("Tugas tidak ditemukan"),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Tugas", style: AppTextStyles.title),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Edit Feature
            },
            child: const Text("Edit", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppLayout.cardPadding),
              children: [
                // CARD DETAIL UTAMA
                Container(
                  padding: const EdgeInsets.all(AppLayout.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Judul Tugas"),
                      Text(task.title, style: AppTextStyles.title.copyWith(fontSize: 18)),
                      
                      const SizedBox(height: AppLayout.mediumSpacing),
                      
                      _buildLabel("Mata Kuliah"),
                      Text(task.course, style: AppTextStyles.section),
                      
                      const SizedBox(height: AppLayout.mediumSpacing),
                      
                      _buildLabel("Deadline"),
                      Text(
                        DateFormat('d MMM yyyy').format(task.deadline), 
                        style: AppTextStyles.section
                      ),

                      const SizedBox(height: AppLayout.mediumSpacing),

                      _buildLabel("Status"),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isDone 
                              ? AppColors.primaryBlue.withOpacity(0.1) 
                              : AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isDone ? "Selesai" : "Berjalan",
                          style: TextStyle(
                            color: _isDone ? AppColors.primaryBlue : AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppLayout.largeSpacing),

                // BAGIAN PENYELESAIAN (CHECKBOX)
                const Text("Penyelesaian", style: AppTextStyles.section),
                const SizedBox(height: AppLayout.smallSpacing),
                
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: CheckboxListTile(
                    value: _isDone,
                    onChanged: (val) {
                      setState(() {
                        _isDone = val ?? false;
                      });
                    },
                    title: const Text("Tugas sudah selesai", style: AppTextStyles.body),
                    subtitle: const Text("Centang jika tugas sudah final.", style: AppTextStyles.caption),
                    activeColor: AppColors.primaryBlue,
                    controlAffinity: ListTileControlAffinity.leading, 
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),

                const SizedBox(height: AppLayout.largeSpacing),

                // BAGIAN CATATAN
                const Text("Catatan", style: AppTextStyles.section),
                const SizedBox(height: AppLayout.smallSpacing),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppLayout.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surface, 
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: task.note.isNotEmpty // Menggunakan field note
                    ? Text(task.note, style: AppTextStyles.body)
                    : const Text(
                        "Tidak ada catatan.", 
                        style: AppTextStyles.caption
                      ),
                ),
              ],
            ),
          ),

          // TOMBOL SIMPAN 
          Container(
            padding: const EdgeInsets.all(AppLayout.cardPadding),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppLayout.elementHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_isDone != task.isDone && task.id != null) {
                    // Update ke API
                    taskController.toggleTaskStatus(task.id!); 
                  }
                  
                  Navigator.pop(context); 
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Perubahan berhasil disimpan"),
                      backgroundColor: AppColors.primaryBlue,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(fontSize: 12, color: AppColors.textMuted),
      ),
    );
  }
}