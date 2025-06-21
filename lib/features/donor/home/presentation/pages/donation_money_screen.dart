import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DonationMoneyPage extends StatefulWidget {
  const DonationMoneyPage({super.key, required this.campaignId});
  final int campaignId;

  @override
  DonationMoneyPageState createState() => DonationMoneyPageState();
}

class DonationMoneyPageState extends State<DonationMoneyPage>
    with TickerProviderStateMixin {
  final _montoController = TextEditingController();
  final _nombreCuentaController = TextEditingController();
  final _numeroCuentaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _montoFormKey = GlobalKey<FormState>();

  File? _imageFile;
  String? _selectedDivisa;
  bool _isLoading = false;
  final List<String> _divisas = ['BS'];
  String? _qrData;

  // Estados para controlar la visibilidad de los formularios
  bool _showMontoForm = true;
  bool _showQRForm = false;
  bool _showDatosForm = false;

  // Controladores de animación
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Controladores para las animaciones de los formularios

  late AnimationController _montoFormController;
  late AnimationController _qrFormController;
  late AnimationController _datosFormController;
  late Animation<Offset> _montoFormAnimation;
  late Animation<Offset> _datosFormAnimation;

  // Paleta de colores consistente
  static const Color primaryDark = Color(0xFF0D1B2A);
  static const Color primaryBlue = Color(0xFF1B263B);
  static const Color accentBlue = Color(0xFF415A77);
  static const Color lightBlue = Color(0xFF778DA9);
  static const Color cream = Color(0xFFE0E1DD);
  static const Color accent = Color(0xFFFFB700);
  static const Color white = Color(0xFFFFFFFE);
  static const Color errorColor = Color(0xFFE63946);
  static const Color successColor = Color(0xFF2A9D8F);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Animaciones principales
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animaciones para los formularios
    _montoFormController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _qrFormController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _datosFormController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _montoFormAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _montoFormController,
            curve: Curves.elasticOut,
          ),
        );

    _datosFormAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _datosFormController,
            curve: Curves.elasticOut,
          ),
        );

    _fadeController.forward();
    _slideController.forward();
    _montoFormController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _montoFormController.dispose();
    _qrFormController.dispose();
    _datosFormController.dispose();
    _montoController.dispose();
    _nombreCuentaController.dispose();
    _numeroCuentaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.selectionClick();

    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        print('Comprobante seleccionado: ${image.path}');
        _showSuccessSnackBar('Comprobante seleccionado correctamente');
      }
    } catch (e) {
      _showErrorSnackBar('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _donateMoney() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    if (_imageFile == null) {
      _showErrorSnackBar('Por favor selecciona un comprobante');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://backenddonaciones.onrender.com/api/donaciones'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'tipo_donacion': 'dinero',
          'fecha_donacion': DateTime.now().toIso8601String(),
          'id_donante': prefs.getInt('donante_id').toString(),
          'id_campana': widget.campaignId,
        }),
      );
      final responseBody = json.decode(response.body);
      print(
        'Procesando donación: ${responseBody['message'] ?? responseBody['error'] ?? 'Error desconocido'}',
      );
      if (response.statusCode != 201) {
        _showErrorSnackBar(
          'Error al procesar donación: ${responseBody['message'] ?? responseBody['error'] ?? 'Error desconocido'}',
        );
        return;
      }

      print('Donación procesada exitosamente: ${responseBody ?? 'Correcto'}');

      final responseMoney = await http.put(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/donaciones-en-dinero/${responseBody['id']}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'monto': _montoController.text,
          'divisa': 'BS',
          'nombre_cuenta': _nombreCuentaController.text,
          'numero_cuenta': _numeroCuentaController.text,
          'comprobante_url': base64.encode(_imageFile!.readAsBytesSync()),
          'estado_validacion': 'pendiente',
        }),
      );
      print('''

      https://backenddonaciones.onrender.com/api/donaciones-en-dinero/${responseBody['id_donacion']}
      'monto': ${_montoController.text},
      'divisa': $_selectedDivisa,
      'nombre_cuenta': ${_nombreCuentaController.text},
      'numero_cuenta': ${_numeroCuentaController.text},
      'comprobante_url': ${base64.encode(_imageFile!.readAsBytesSync())},
      'estado_validacion': 'pendiente',

''');
      final responseMoneyBody = json.decode(responseMoney.body);
      print(
        'Error al procesar donación en dinero: ${responseMoneyBody['message'] ?? responseMoneyBody['error'] ?? 'Error desconocido'} - ${responseMoney.statusCode}',
      );
      if (responseMoney.statusCode != 200) {
        _showErrorSnackBar(
          'Error al procesar donación en dinero: ${responseMoneyBody['message'] ?? responseMoneyBody['error'] ?? 'Error desconocido'}',
        );
        return;
      }

      print(
        'Donación en dinero procesada exitosamente: ${responseMoneyBody['message'] ?? 'Correcto'} - ${responseMoney.statusCode}',
      );
      if (!mounted) return;

      _showSuccessDialog();
    } catch (e) {
      _showErrorSnackBar('Error al procesar donación: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openImagePicker(File image) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Comprobante seleccionado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.grey[200],
            constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
            child: Image.file(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('No se pudo cargar la imagen'));
              },
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: accent),
                      ),
                    ),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                        color: accent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Quitar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: white)),
            ),
          ],
        ),
        backgroundColor: errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: white)),
            ),
          ],
        ),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  color: successColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Donación Exitosa!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tu donación ha sido registrada correctamente. ¡Gracias por tu generosidad!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: accentBlue, height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: primaryDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: lightBlue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          filled: true,
          fillColor: cream.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: accent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: _selectedDivisa,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona una divisa';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Divisa',
          labelStyle: TextStyle(
            color: lightBlue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.currency_exchange_rounded,
              color: accent,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: cream.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: accent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        items: _divisas.map((String divisa) {
          return DropdownMenuItem<String>(
            value: divisa,
            child: Text(
              divisa,
              style: const TextStyle(
                color: primaryDark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedDivisa = newValue;
          });
        },
        dropdownColor: white,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: lightBlue),
      ),
    );
  }

  Future<void> _handleGenerateQR() async {
    if (_montoFormKey.currentState!.validate()) {
      await _generateQR();
      if (_qrData != null) {
        setState(() {
          _showMontoForm = false;
          _showDatosForm = true;
        });
        _datosFormController.forward();
      }
    }
  }

  void _handleBack() {
    if (_showDatosForm) {
      setState(() {
        _showDatosForm = false;
        _showMontoForm = true;
      });
    } else if (_showQRForm) {
      setState(() {
        _showQRForm = false;
        _showMontoForm = true;
      });
    }
  }

  Future<void> _generateQR() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://devbol.com/api/create'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('admin:secreto123'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'monto': double.parse(_montoController.text)}),
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<int> bytes = base64.decode(data['cadena_base64']);
        String decodedText = utf8.decode(bytes);

        print('Base64 recibido (original): $decodedText');

        // Ejemplo: TRANSACCION:684bd84eb6421|MONTO:200

        // Limpiar y dar formato bonito
        String textoLimpio =
            '${decodedText.replaceAll(':', ' =>') // TRANSACCION => 684bd...
            .replaceAll('|', '||') // Salto de línea entre campos
            .replaceAllMapped(RegExp(r'[^\x20-\x7E]'), (m) => '')}Bs'; // elimina no ASCII

        setState(() {
          _qrData = textoLimpio;
        });
      } else {
        _showErrorSnackBar('Error al generar el QR: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error al generar el QR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMontoForm() {
    return SlideTransition(
      position: _montoFormAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryDark.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Form(
          key: _montoFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingrese el Monto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildCustomTextField(
                controller: _montoController,
                label: 'Monto',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un monto válido';
                  }
                  if (double.parse(value) <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCustomDropdown(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleGenerateQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryDark,
                            ),
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Generar QR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosForm() {
    return SlideTransition(
      position: _datosFormAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryDark.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Código QR Generado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 24),
              if (_qrData != null)
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cream.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: PrettyQrView.data(
                    data: _qrData!,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(color: primaryDark),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Cargar el comprobante
              GestureDetector(
                onTap: () {
                  if (_imageFile == null) {
                    _pickImage(); // Selecciona imagen
                  } else {
                    _openImagePicker(_imageFile!); // Muestra imagen ya cargada
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromARGB(38, 252, 249, 249),
                    ),
                  ),

                  child: _imageFile == null
                      ? Center(
                          child: Text(
                            'Toca para seleccionar un comprobante',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 99, 182, 45),
                              ),
                              Text(
                                'Toca para ver el comprobante',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 99, 182, 45),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Datos de la Cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildCustomTextField(
                controller: _nombreCuentaController,
                label: 'Nombre de la Cuenta',
                icon: Icons.account_box_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre de la cuenta';
                  }
                  return null;
                },
              ),
              _buildCustomTextField(
                controller: _numeroCuentaController,
                label: 'Número de Cuenta',
                icon: Icons.account_balance_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número de cuenta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _handleBack,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: accent),
                        ),
                      ),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                          color: accent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _donateMoney,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryDark,
                                ),
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Finalizar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: accent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryDark),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          'Donar en Dinero',
          style: TextStyle(
            color: primaryDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue.withOpacity(0.9), cream.withOpacity(1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryBlue, accentBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryDark.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.volunteer_activism_rounded,
                              color: white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tu Donación',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cada contribución cuenta',
                                  style: TextStyle(
                                    color: white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showMontoForm) _buildMontoForm(),
                  if (_showDatosForm) _buildDatosForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
