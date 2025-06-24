// lib/utils/helper.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//* Color
Color cPrimary = const Color(0xffF1C615); // Ini kuning/orange
Color cSecondary = const Color(0xff3A3A3A);
Color cTextBlue = const Color(0xff4E4B66);
Color cBlack = const Color(0xff000000);
Color cWhite = const Color(0xffFFFFFF);
Color cSmokeWhite = const Color(0xffF5F5F5);
Color cGrey = const Color(0xffF1F1F5); // Untuk border default
Color cError = const Color(0xffFF4545);
Color cSuccess = const Color(0xff007360); // Tambahkan warna success

//* Space
// Pertahankan yang paling sering digunakan, atau yang memberi fleksibilitas
const Widget hsTiny = SizedBox(width: 4.0); // Diperbarui untuk hsTiny
const Widget hsSmall = SizedBox(width: 8.0); // Diperbarui untuk hsSmall
const Widget hsMedium = SizedBox(width: 16.0); // Diperbarui untuk hsMedium

const Widget vsTiny = SizedBox(height: 4.0); // Diperbarui untuk vsTiny
const Widget vsSmall = SizedBox(height: 8.0); // Diperbarui untuk vsSmall
const Widget vsMedium = SizedBox(height: 16.0); // Diperbarui untuk vsMedium
const Widget vsLarge = SizedBox(height: 24.0); // Diperbarui untuk vsLarge
const Widget vsXLarge = SizedBox(
  height: 36.0,
); // Digunakan di LoginScreen dan lainnya

//* Font Weight
FontWeight thin = FontWeight.w100;
FontWeight extralight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500; // Digunakan
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700; // Digunakan
FontWeight extrabold = FontWeight.w800;

//* TextStyle
// Pastikan definisi TextStyle ini ada agar tidak error
TextStyle headline1 = GoogleFonts.poppins(fontSize: 40);
TextStyle headline2 = GoogleFonts.poppins(fontSize: 34);
TextStyle headline3 = GoogleFonts.poppins(
  fontSize: 28,
); // Contoh, sesuaikan jika Anda punya
TextStyle headline4 = GoogleFonts.poppins(fontSize: 24); // Digunakan
TextStyle subtitle1 = GoogleFonts.poppins(fontSize: 16); // Digunakan
TextStyle subtitle2 = GoogleFonts.poppins(fontSize: 14); // Digunakan
TextStyle caption = GoogleFonts.poppins(fontSize: 12); // Digunakan
TextStyle overline = GoogleFonts.poppins(fontSize: 10);

//* InputBorder Definitions for TextFormField
// Pastikan ini menggunakan borderRadius: BorderRadius.circular(16)
OutlineInputBorder defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16), // Sesuai dengan definisi Anda
  borderSide: BorderSide(
    color: cGrey,
    width: 1.0,
  ), // Gunakan cGrey atau warna default yang lebih halus
);

OutlineInputBorder focusedInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16), // Konsisten dengan default
  borderSide: BorderSide(
    color: cPrimary.withAlpha(90),
    width: 2.0,
  ), // Warna primary saat fokus, lebih tebal
);

OutlineInputBorder errorInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16), // Konsisten
  borderSide: BorderSide(
    color: cError,
    width: 1.0,
  ), // Warna error saat ada kesalahan
);

OutlineInputBorder focusedErrorInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16), // Konsisten
  borderSide: BorderSide(color: cError, width: 1.0), // Tetap error saat fokus
);

BoxShadow defaultShadow = BoxShadow(
  color: cSecondary.withAlpha(20), // Transparansi 20 dari cSecondary
  blurRadius: 5,
  spreadRadius: 5,
);

// Function untuk Category Color (Sudah digunakan dan perlu dipertahankan)
Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'business':
      return Colors.green[600]!;
    case 'entertainment':
      return Colors.purple[600]!;
    case 'general':
      return Colors.blue[600]!;
    case 'health':
      return Colors.pink[600]!;
    case 'science':
      return Colors.orange[600]!;
    case 'sports':
      return Colors.red[600]!;
    case 'technology':
    case 'tech':
      return Colors.indigo[600]!;
    case 'life':
      return Colors.teal[600]!;
    default:
      return Colors
          .lightBlue[600]!; // Default warna pink jika tidak ada kategori cocok
  }
}
