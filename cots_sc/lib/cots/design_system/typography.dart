import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textBlack
  );

  static const TextStyle section = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textBlack
  );

  static const TextStyle body = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w400, 
    color: AppColors.textBlack
  );
 
  static const TextStyle caption = TextStyle(
    fontSize: 12, 
    fontWeight: FontWeight.w400, 
    color: AppColors.textMuted 
  );

  static const TextStyle button = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w600, 
    color: AppColors.surface 
  );
}