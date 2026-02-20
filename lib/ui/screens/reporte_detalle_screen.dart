import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/building_list_response.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ReporteDetalleScreen extends StatelessWidget {
  final BuildingData edificio;
  final double puntuacion;

  const ReporteDetalleScreen(
      {super.key, required this.edificio, required this.puntuacion});

  String _getMensajeSismico(double score) {
    if (score <= 0.1) return "No se ha registrado una puntuación válida para este edificio.";
    if (score <= 3.0) return "El edificio presenta una vulnerabilidad sísmica ALTA. Se requiere intervención urgente y una evaluación detallada inmediata.";
    if (score <= 6.5) return "Basado en los datos ingresados, el edificio presenta una vulnerabilidad sísmica MODERADA. Se recomienda realizar una evaluación detallada por un ingeniero estructural.";
    return "El edificio presenta una vulnerabilidad sísmica BAJA. Cumple con los estándares básicos según la inspección visual.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Resultados",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _generarPDF(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4A4A),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Descargar PDF",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Resumen del Edificio",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 25),

            _buildInfoTile(Icons.apartment_rounded, "Nombre del Edificio", edificio.nombreEdificio),
            _buildInfoTile(Icons.location_on_rounded, "Ubicación", edificio.direccion ?? "No disponible"),
            _buildInfoTile(Icons.construction_rounded, "Tipo de Construcción", edificio.usoPrincipal ?? "Estructura de Concreto"),
            _buildInfoTile(Icons.calendar_month_rounded, "Año de Construcción", edificio.anioConstruccion?.toString() ?? "Dato no disponible"),

            const SizedBox(height: 35),
            const Text("Evaluación de Vulnerabilidad Sísmica",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 12),
            Text(_getMensajeSismico(puntuacion),
                style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4)),


            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Puntaje de Vulnerabilidad",
                      style: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(puntuacion > 0 ? puntuacion.toStringAsFixed(1) : "0.0",
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                ],
              ),
            ),

            const SizedBox(height: 40),
            //ANEXO DE IMAGENES
            if ((edificio.fotoUrl != null && edificio.fotoUrl!.isNotEmpty) ||
                (edificio.graficoUrl != null && edificio.graficoUrl!.isNotEmpty)) ...[
              const Text("Anexos Fotográficos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 15),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (edificio.fotoUrl != null && edificio.fotoUrl!.isNotEmpty)
                      _buildPreviewImage("Foto Principal", edificio.fotoUrl!),
                    if (edificio.graficoUrl != null && edificio.graficoUrl!.isNotEmpty)
                      _buildPreviewImage("Plano / Gráfico", edificio.graficoUrl!),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F1F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF245A88), size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(value, style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
// --- COPIAR DESDE AQUÍ ---
  Widget _buildPreviewImage(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              height: 110,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 110, width: 150, color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
// --- HASTA AQUÍ ---
  // --- LÓGICA DEL PDF ACTUALIZADA Y CORREGIDA ---
  Future<void> _generarPDF(BuildContext context) async {
    final pdf = pw.Document();

    pw.MemoryImage? imageFoto;
    pw.MemoryImage? imageGrafico;

    try {
      if (edificio.fotoUrl != null && edificio.fotoUrl!.isNotEmpty) {
        final response = await http.get(Uri.parse(edificio.fotoUrl!));
        if (response.statusCode == 200) {
          imageFoto = pw.MemoryImage(response.bodyBytes);
        }
      }
      if (edificio.graficoUrl != null && edificio.graficoUrl!.isNotEmpty) {
        final response = await http.get(Uri.parse(edificio.graficoUrl!));
        if (response.statusCode == 200) {
          imageGrafico = pw.MemoryImage(response.bodyBytes);
        }
      }
    } catch (e) {
      debugPrint("Error cargando imágenes para el PDF: $e");
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            pw.Text("Reporte de Evaluación Estructural",
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.SizedBox(height: 20),

            pw.Text("Datos Generales", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),

            _buildPdfInfoRow("Nombre del Edificio", edificio.nombreEdificio),
            _buildPdfInfoRow("Ubicación", edificio.direccion ?? "No disponible"),
            _buildPdfInfoRow("Tipo de Construcción", edificio.usoPrincipal ?? "Estructura de Concreto"),
            _buildPdfInfoRow("Año de Construcción", edificio.anioConstruccion?.toString() ?? "N/A"),

            pw.SizedBox(height: 30),
            pw.Text("Vulnerabilidad Sísmica", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text(_getMensajeSismico(puntuacion), style: const pw.TextStyle(fontSize: 12)),

            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("PUNTAJE OBTENIDO:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(puntuacion.toStringAsFixed(1),
                      style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                ],
              ),
            ),

            // --- SECCIÓN DE ANEXOS (CORREGIDO EL CIERRE DE LISTA) ---
            if (imageFoto != null || imageGrafico != null) ...[
              pw.SizedBox(height: 40),
              pw.Text("Anexos Fotográficos", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 20),

              if (imageFoto != null) ...[
                pw.Text("Foto del Edificio:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Center(child: pw.Image(imageFoto, height: 200, fit: pw.BoxFit.contain)),
                pw.SizedBox(height: 20),
              ],

              if (imageGrafico != null) ...[
                pw.Text("Plano del Edificio:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Center(child: pw.Image(imageGrafico, height: 200, fit: pw.BoxFit.contain)),
              ],
            ], // <--- AQUÍ SE CIERRA EL OPERADOR DE PROPAGACIÓN DE LAS IMÁGENES

            pw.Spacer(),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 40),
              child: pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Generado automáticamente - Evaluación de Riesgo Sísmico",
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Reporte_${edificio.nombreEdificio}.pdf',
    );
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        children: [
          pw.Container(
            width: 6,
            height: 6,
            decoration: const pw.BoxDecoration(color: PdfColors.blue800, shape: pw.BoxShape.circle),
          ),
          pw.SizedBox(width: 10),
          pw.Text("$label: ", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
        ],
      ),
    );
  }
}