import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake temporal data (luego lo reemplazamos por la API)
    final schedules = [
      {
        "id": 1,
        "therapist_name": "Dr. Carlos Núñez",
        "patient_name": "Juan Pérez",
        "legal_responsible_name": "María Gómez",
        "start_at": DateTime.parse("2026-12-22T21:30:00Z"),
        "ends_at": DateTime.parse("2026-12-22T22:00:00Z"),
        "status": "SCHEDULED"
      },
      {
        "id": 2,
        "therapist_name": "Dra. Sofía Lúcar",
        "patient_name": "Ana Torres",
        "legal_responsible_name": "Luis Torres",
        "start_at": DateTime.parse("2026-12-22T18:00:00Z"),
        "ends_at": DateTime.parse("2026-12-22T18:30:00Z"),
        "status": "SCHEDULED"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Próximas Sesiones",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            ...schedules.map((s) => _ScheduleCard(data: s)).toList()
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ScheduleCard({required this.data});

  Color _getStatusColor(String status) {
    switch (status) {
      case "SCHEDULED":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      case "FINISHED":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = data["start_at"] as DateTime;
    final end = data["ends_at"] as DateTime;

    final formattedDate = DateFormat("dd MMM yyyy, hh:mm a").format(start);
    final formattedRange =
        "${DateFormat("hh:mm a").format(start)} - ${DateFormat("hh:mm a").format(end)}";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Fecha ----------
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue[700], size: 20),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- Información ----------
          _infoRow("Terapeuta", data["therapist_name"]),
          _infoRow("Paciente", data["patient_name"]),
          _infoRow("Responsable Legal", data["legal_responsible_name"]),

          const SizedBox(height: 12),

          // ---------- Rango horario ----------
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 20),
              const SizedBox(width: 6),
              Text(
                formattedRange,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------- Estado ----------
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _getStatusColor(data["status"]).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data["status"],
                style: TextStyle(
                  color: _getStatusColor(data["status"]),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
