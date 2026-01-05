import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart'; 

import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';

class TambahTugasPage extends StatefulWidget {
  const TambahTugasPage({super.key});

  @override
  State<TambahTugasPage> createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController(); 
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tambah Tugas", style: AppTextStyles.title),
        backgroundColor: AppColors.surface, 
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppLayout.cardPadding), 
          children: [
            const Text("Judul Tugas", style: AppTextStyles.section),
            const SizedBox(height: AppLayout.smallSpacing),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Masukkan judul tugas",
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, 
                  horizontal: 16
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                fillColor: AppColors.surface,
                filled: true,
              ),
              validator: (value) => value!.isEmpty ? "Judul tugas wajib diisi" : null,
            ),
            
            const SizedBox(height: AppLayout.mediumSpacing),

            // MATA KULIAH
            const Text("Mata Kuliah", style: AppTextStyles.section),
            const SizedBox(height: AppLayout.smallSpacing),
            TextFormField(
              controller: _courseController,
              decoration: InputDecoration(
                hintText: "Pilih mata kuliah",
                hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                fillColor: AppColors.surface,
                filled: true,
              ),
            ),

            const SizedBox(height: AppLayout.mediumSpacing),

            // DEADLINE
            const Text("Deadline", style: AppTextStyles.section),
            const SizedBox(height: AppLayout.smallSpacing),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primaryBlue,
                          onPrimary: Colors.white,
                          onSurface: AppColors.textBlack,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: AppLayout.elementHeight, // Tinggi 48
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  color: AppColors.surface,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null 
                        ? "Pilih tanggal" 
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      style: _selectedDate == null 
                          ? AppTextStyles.caption.copyWith(fontSize: 14) 
                          : AppTextStyles.body,
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppLayout.cardPadding),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppLayout.elementHeight, // Tinggi 48
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppLayout.cardRadius)
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: AppColors.textBlack)),
                ),
              ),
            ),
            const SizedBox(width: AppLayout.mediumSpacing),
            Expanded(
              child: SizedBox(
                height: AppLayout.elementHeight, // Tinggi 48
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppLayout.cardRadius)
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedDate != null) {
                      // Tampilkan Loading
                      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
                      
                      try {
                        final newTask = Task(
                          title: _titleController.text,
                          course: _courseController.text,
                          deadline: _selectedDate!,
                          status: 'BERJALAN', // Default Status API
                        );
                        
                        await Provider.of<TaskController>(context, listen: false).addTask(newTask);
                        
                        Navigator.pop(context); // Tutup Loading
                        Navigator.pop(context); // Tutup Halaman
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil menambah tugas")));
                      } catch (e) {
                        Navigator.pop(context); // Tutup Loading
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
                      }
                    } else if (_selectedDate == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mohon pilih tanggal deadline"))
                      );
                    }
                  },
                  child: const Text("Simpan", style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}