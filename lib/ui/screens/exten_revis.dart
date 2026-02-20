import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/inspection_service.dart';
import 'otros_peligros_page.dart';

class ExtensionRevisionPage extends StatefulWidget {
  final int idEdificio;
  // --- ARREGLO: Agregamos los campos faltantes al constructor ---
  final String nombreEdificio;
  final String direccion;
  final String anioConstruccion;
  final String tipoSuelo;
  final int numeroPisos;
  final String ciudad;

  const ExtensionRevisionPage({
    super.key,
    required this.idEdificio,
    required this.nombreEdificio,
    required this.direccion,
    required this.anioConstruccion,
    required this.tipoSuelo,
    required this.ciudad,
    required this.numeroPisos,
  });

  @override
  State<ExtensionRevisionPage> createState() => _ExtensionRevisionPageState();
}

class _ExtensionRevisionPageState extends State<ExtensionRevisionPage> {
  String _exteriorSeleccion = 'Parcial';
  String _interiorSeleccion = 'No';
  String _revisionPlanosSeleccion = 'No';
  String _requiereInspeccionSeleccion = 'No';
  String _fuenteSueloEstado = 'EST';
  String _fuentePeligrosEstado = 'EST';

  final TextEditingController _sueloController = TextEditingController();
  final TextEditingController _peligrosController = TextEditingController();
  final TextEditingController _contactoController = TextEditingController();

  bool _isLoading = false;

  Future<void> _guardarInspeccion() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      final userId = prefs.getString('userId') ?? '0';

      final Map<String, dynamic> inspeccionData = {
        "id_edificio": widget.idEdificio,
        "id_usuario": int.parse(userId),
        "alcance_exterior": _exteriorSeleccion,
        "alcance_interior": _interiorSeleccion,
        "revision_planos": _revisionPlanosSeleccion == 'SI',
        "fuente_suelo": "${_sueloController.text} ($_fuenteSueloEstado)",
        "fuente_peligros": "${_peligrosController.text} ($_fuentePeligrosEstado)",
        "contacto_persona": _contactoController.text,
        "requiere_nivel2": _requiereInspeccionSeleccion == 'SI',
        "otros_peligros": {
          "exterior_detalle": _exteriorSeleccion,
          "interior_detalle": _interiorSeleccion,
        },
        "puntuacion_final": 6.5,
      };

      final exito = await InspectionService.saveInspection(inspeccionData, token);

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspección guardada exitosamente'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Error en el servidor");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la inspección'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extensión de la revisión'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Exterior', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      _buildRadioOption('Parcial', _exteriorSeleccion, (v) => setState(() => _exteriorSeleccion = v!)),
                      _buildRadioOption('Todos los lados', _exteriorSeleccion, (v) => setState(() => _exteriorSeleccion = v!)),
                      _buildRadioOption('Aéreo', _exteriorSeleccion, (v) => setState(() => _exteriorSeleccion = v!)),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 130,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Interior', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      _buildRadioOption('No', _interiorSeleccion, (v) => setState(() => _interiorSeleccion = v!)),
                      _buildRadioOption('Visible', _interiorSeleccion, (v) => setState(() => _interiorSeleccion = v!)),
                      _buildRadioOption('Ingresó', _interiorSeleccion, (v) => setState(() => _interiorSeleccion = v!)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text('Revisión de planos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: [
                Expanded(child: _buildRadioOption('No', _revisionPlanosSeleccion, (v) => setState(() => _revisionPlanosSeleccion = v!))),
                Expanded(child: _buildRadioOption('SI', _revisionPlanosSeleccion, (v) => setState(() => _revisionPlanosSeleccion = v!))),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel('Fuente del tipo de suelo'),
            _buildSelectorField(
              controller: _sueloController,
              label: '',
              dropdownValue: _fuenteSueloEstado,
              onDropdownChanged: (val) => setState(() => _fuenteSueloEstado = val!),
            ),
            const SizedBox(height: 15),
            _buildLabel('Fuente del peligros geológicos'),
            _buildSelectorField(
              controller: _peligrosController,
              label: '',
              dropdownValue: _fuentePeligrosEstado,
              onDropdownChanged: (val) => setState(() => _fuentePeligrosEstado = val!),
            ),
            const SizedBox(height: 15),
            _buildLabel('Contacto de la persona'),
            TextField(
              controller: _contactoController,
              decoration: _inputDecoration(''),
            ),
            const SizedBox(height: 25),
            const Text('¿Requiere inspección Nivel 2?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: [
                Expanded(child: _buildRadioOption('No', _requiereInspeccionSeleccion, (v) => setState(() => _requiereInspeccionSeleccion = v!))),
                Expanded(child: _buildRadioOption('SI', _requiereInspeccionSeleccion, (v) => setState(() => _requiereInspeccionSeleccion = v!))),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtrosPeligrosPage(
                        idEdificio: widget.idEdificio,
                        nombreEdificio: widget.nombreEdificio,
                        direccion: widget.direccion,
                        anioConstruccion: widget.anioConstruccion,
                        tipoSuelo: widget.tipoSuelo,
                        numeroPisos: widget.numeroPisos,
                        ciudad: widget.ciudad, // Asegúrate de que widget.ciudad venga del constructor
                        // --- DATOS NUEVOS QUE FALTABAN ---
                        alcanceExterior: _exteriorSeleccion,
                        alcanceInterior: _interiorSeleccion,
                        revisionPlanos: _revisionPlanosSeleccion == 'SI',
                        contacto: _contactoController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Siguiente', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    filled: true,
    fillColor: Colors.blue.shade50.withOpacity(0.2),
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  Widget _buildRadioOption(String title, String? groupValue, Function(String?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSelectorField({
    required TextEditingController controller,
    required String label,
    required String dropdownValue,
    required ValueChanged<String?> onDropdownChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(controller: controller, decoration: _inputDecoration(label)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              items: ['EST', 'OTRO'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: onDropdownChanged,
            ),
          ),
        ),
      ],
    );
  }
}