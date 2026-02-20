import 'package:flutter/material.dart';
import 'resumen_page.dart';

class ExtensionRevisionNoEstructuralPage extends StatefulWidget {
  // 1. Recibimos TODO lo que viene de las pantallas anteriores
  final int idEdificio;
  final String nombreEdificio;
  final String direccion;
  final String anioConstruccion;
  final String tipoSuelo;
  final int numeroPisos;
  final String ciudad;
  final String alcanceExterior;
  final String alcanceInterior;
  final bool revisionPlanos;
  final String contacto;

  const ExtensionRevisionNoEstructuralPage({
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
  State<ExtensionRevisionNoEstructuralPage> createState() => _ExtensionRevisionNoEstructuralPageState();
}

class _ExtensionRevisionNoEstructuralPageState extends State<ExtensionRevisionNoEstructuralPage> {
  String? _opcionSeleccionada = 'No se sabe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extensión de la revisión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Se requiere una evaluación detallada de elementos no estructurales?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildRadio('Sí, hay peligro de caída de elementos no estructurales'),
            _buildRadio('No, existe amenaza y debe ser mitigada'),
            _buildRadio('No, no existe peligro'),
            _buildRadio('No se sabe'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 2. Pasamos la estafeta con TODOS los datos al Resumen
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
                        // Aquí enviamos la opción seleccionada en esta pantalla
                        evaluacionDetallada: _opcionSeleccionada ?? 'No se sabe',
                        // Como no queremos más clases, mandamos un mapa vacío de peligros extra o valores por defecto
                        otrosPeligros: {
                          "no_estructural": _opcionSeleccionada!.contains('Sí'),
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Siguiente', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String titulo) {
    return RadioListTile<String>(
      title: Text(titulo),
      value: titulo,
      groupValue: _opcionSeleccionada,
      onChanged: (value) => setState(() => _opcionSeleccionada = value),
    );
  }
}