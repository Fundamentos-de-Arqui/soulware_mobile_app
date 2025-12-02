import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soulware_app/core/services/session_provider.dart';
import 'package:soulware_app/features/sessions/domain/models/session_model.dart';
import 'package:soulware_app/features/sessions/presentation/sessions_controller.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final session = ref.read(sessionServiceProvider);
      final token = await session.getAccessToken();
      final profileId = await session.getProfileId();

      if (token != null && profileId != null) {
        ref
            .read(sessionsControllerProvider.notifier)
            .loadSessions(page: 0, size: 20, therapistId: profileId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("Sesiones")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(sessionsControllerProvider.notifier)
              .loadSessions(page: 0, size: 20);
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: state.sessions.length,
                itemBuilder: (_, i) =>
                    _ScheduleCard(model: state.sessions[i], ref: ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ======================= CARD ADAPTADA =======================
//

class _ScheduleCard extends StatelessWidget {
  final SessionModel model;
  final WidgetRef ref;

  const _ScheduleCard({required this.model, required this.ref});

  Color _getStatusColor(String status) {
    switch (status) {
      case "SCHEDULED":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      case "DONE":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Convierte string "2025-10-22T15:00:00Z[Etc/UTC]" a DateTime válido
  DateTime? _safeParseDate(String raw) {
    try {
      final clean = raw.split('[').first; // "2025-10-22T15:00:00Z"
      return DateTime.parse(clean);
    } catch (_) {
      return null;
    }
  }

  void _confirmStatusChange(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Marcar esta sesión como DONE?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // SEGURO

              final controller = ref.read(sessionsControllerProvider.notifier);

              controller.updateStatus(model.id);
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = _safeParseDate(model.startAt);
    final end = _safeParseDate(model.endsAt);

    final formattedDate = start != null
        ? DateFormat("dd MMM yyyy, hh:mm a").format(start)
        : model.startAt;

    final formattedRange = (start != null && end != null)
        ? "${DateFormat("hh:mm a").format(start)} - ${DateFormat("hh:mm a").format(end)}"
        : "${model.startAt} → ${model.endsAt}";

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
          ),
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
          _infoRow("Terapeuta", model.therapistName),
          _infoRow("Paciente", model.patientName),
          _infoRow("Responsable", model.legalResponsibleName),

          const SizedBox(height: 12),

          // ---------- Rango ----------
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
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _getStatusColor(model.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                model.status,
                style: TextStyle(
                  color: _getStatusColor(model.status),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (model.status == "SCHEDULED")
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _confirmStatusChange(context),
                icon: const Icon(Icons.check),
                label: const Text("Marcar como DONE"),
              ),
            ),
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
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
