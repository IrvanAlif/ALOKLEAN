from pathlib import Path
p=Path('lib/pages/user/booking_page.dart')
lines=p.read_text('utf-8').splitlines(keepends=True)
new_block=[
'    if (_formKey.currentState?.validate() ?? false) {\n',
'      final price = int.tryParse(_priceController.text) ?? 0;\n',
'\n',
'      if (_selectedDate == null || _selectedTime == null) {\n',
'        ScaffoldMessenger.of(context).showSnackBar(\n',
'          const SnackBar(\n',
'            content: Text(\'Pilih tanggal dan jam layanan terlebih dahulu.\'),\n',
'            backgroundColor: Colors.red,\n',
'          ),\n',
'        );\n',
'        return;\n',
'      }\n',
'\n',
'      if (price <= 0) {\n',
'        ScaffoldMessenger.of(context).showSnackBar(\n',
'          const SnackBar(\n',
'            content: Text(\'Harga harus lebih dari 0\'),\n',
'            backgroundColor: Colors.red,\n',
'          ),\n',
'        );\n',
'        return;\n',
'      }\n',
'\n'
]
lines[120:140]=new_block
p.write_text(''.join(lines), 'utf-8')
print('submit block fixed')
