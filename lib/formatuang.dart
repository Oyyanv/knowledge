// import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Formatuang extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Menghapus karakter non-digit dari teks
    String cleanText = newValue.text;

    // Mencoba untuk parse teks yang telah dibersihkan sebagai double
    double value = double.tryParse(cleanText) ?? 0;

    // Memformat nilai double dengan format mata uang
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    String formattedText = formatter.format(value);

    // Mengembalikan nilai yang telah diformat
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
