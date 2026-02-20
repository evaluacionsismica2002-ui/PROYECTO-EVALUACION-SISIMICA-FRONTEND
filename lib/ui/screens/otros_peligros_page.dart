import 'package:flutter/material.dart';
import 'resumen_page.dart';

class OtrosPeligrosPage extends StatefulWidget {
  final int idEdificio;
  final String nombreEdificio;
  final String direccion;
  final String anioConstruccion;
  final String tipoSuelo;
  final int numeroPisos;
  final String ciudad;
  // Datos de la pantalla anterior
  final String alcanceExterior;
  final String alcanceInterior;
  final bool revisionPlanos;
  final String contacto;

  const OtrosPeligrosPage({
    super.key,
    required this.idEdificio,
    required this.nombreEdificio,
    required this.direccion,
    required this.anioConstruccion,
    required this.tipoSuelo,
    required this.numeroPisos,
    required this.ciudad,
    required this.alcanceExterior,
    required this.alcanceInterior,
    required this.revisionPlanos,
    required this.contacto,
  });

  @override
  State<OtrosPeligrosPage> createState() => _OtrosPeligrosPageState();
}

class _OtrosPeligrosPageState extends State<OtrosPeligrosPage> {
  bool _golpeteo = false;
  bool _caida = false;
  bool _geologico = false;
  bool _danos = false;
  String? _evaluacionDetallada = 'No';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Otros peligros')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('¿Hay peligros que desencadenan una evaluación detallada?'),
            _buildCheck('Posible golpeteo', _golpeteo, (v) => setState(() => _golpeteo = v!)),
            _buildCheck('Riesgo de caída', _caida, (v) => setState(() => _caida = v!)),
            _buildCheck('Peligro geológico', _geologico, (v) => setState(() => _geologico = v!)),
            _buildCheck('Daños estructurales', _danos, (v) => setState(() => _danos = v!)),
            const Divider(),
            const Text('¿Se requiere una evaluación estructural más detallada?'),
            _buildRadio('Si, se desconoce el tipo de edificio'),
            _buildRadio('Si, resultado menor al limite mínimo'),
            _buildRadio('Si, otros peligros presentes'),
            _buildRadio('No'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade800),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResumenPage(
                      idEdificio: widget.idEdificio,
                      nombreEdificio: widget.nombreEdificio,
                      direccion: widget.direccion,
                      anioConstruccion: widget.anioConstruccion,
                      tipoSuelo: widget.tipoSuelo,
                      numeroPisos: widget.numeroPisos,
                      ciudad: widget.ciudad,
                      alcanceExterior: widget.alcanceExterior,
                      alcanceInterior: widget.alcanceInterior,
                      revisionPlanos: widget.revisionPlanos,
                      contacto: widget.contacto,
                      // Nuevos datos
                      otrosPeligros: {
                        "golpeteo": _golpeteo,
                        "caida_adyacente": _caida,
                        "suelo_f_geologico": _geologico,
                        "deterioro": _danos,
                      },
                      evaluacionDetallada: _evaluacionDetallada ?? 'No',
                    ),
                  ),
                );
              },
              child: const Text('IR AL RESUMEN', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheck(String t, bool v, Function(bool?) onC) => CheckboxListTile(title: Text(t), value: v, onChanged: onC);
  Widget _buildRadio(String t) => RadioListTile(title: Text(t), value: t, groupValue: _evaluacionDetallada, onChanged: (v) => setState(() => _evaluacionDetallada = v as String));
}