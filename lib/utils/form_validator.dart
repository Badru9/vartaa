String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Full name tidak boleh kosong';
  } else if (value.length <= 4) {
    return 'Full name harus melebihi 3 karakter';
  } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
    return 'Full name hanya boleh berisi karakter / huruf';
  }
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username tidak boleh kosong';
  } else if (value.length <= 4) {
    return 'Username harus melebihi 3 karakter';
  } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
    return 'Username hanya boleh berisi karakter / huruf';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number tidak boleh kosong';
  } else if (value.length < 11) {
    return 'NO HP harus melebihi 9 number';
  } else if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
    return 'NO HP hanya mengandung number';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return 'Email tidak boleh kosong';
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Masukkan email yang aktif';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  final RegExp alphabetRegExp = RegExp(r'^(?=.*[a-zA-Z]).*$');
  if (value!.isEmpty) {
    return 'Password tidak boleh kosong';
  } else if (value.length < 8) {
    return 'Password tidak boleh kurang dari 8 karakter';
  } else if (!alphabetRegExp.hasMatch(value)) {
    return 'Password harus mengandung setidaknya satu huruf';
  } else {
    return null;
  }
}

String? validateOtp(String? value) {
  if (value!.isEmpty) {
    return 'OTP code tidak boleh kosong';
  } else if (value.length != 6) {
    return 'Kode OTP harus memiliki 6 number';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Kode OTP hanya berupa number';
  } else {
    return null;
  }
}

String? validateDropdown(String? value) {
  if (value == null || value.isEmpty) {
    return 'Pilih Opsi';
  }
  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Alamat tidak boleh kosong';
  } else if (value.length < 10) {
    return 'Alamat tidak lengkap, Tolong tambahkan detail';
  } else {
    return null;
  }
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Deskripsi tidak boleh kosong';
  } else if (value.length < 10) {
    return 'Deskripsi tidak lengkap, Tolong tambahkan detail';
  } else {
    return null;
  }
}
