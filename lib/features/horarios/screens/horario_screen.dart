import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';
import 'package:sistema_citas_medicas/features/citas/widgets/app_header.dart';
import 'package:sistema_citas_medicas/features/horarios/viewmodels/horario_viewmodel.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {

  // ─────────────────────────────────────────
  // ESTADO LOCAL
  // ─────────────────────────────────────────

  // Días: clave interna → label visible
  final Map<String, String> _diasLabels = {
    'L': 'L', 'M': 'M', 'X': 'X', 'J': 'J', 'V': 'V', 'S': 'S', 'D': 'D',
  };
  Map<String, bool> _diasSeleccionados = {
    'L': false, 'M': false, 'X': false, 'J': false,
    'V': false, 'S': false, 'D': false,
  };

  final _horaInicioCtrl  = TextEditingController(text: '08:00');
  final _horaFinCtrl     = TextEditingController(text: '17:00');
  final _pausaInicioCtrl = TextEditingController(text: '12:00');
  final _pausaFinCtrl    = TextEditingController(text: '13:00');
  DateTime _vigenciaDesde = DateTime.now();

  // ─────────────────────────────────────────
  // INIT — Cargar horario existente
  // ─────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarHorario());
  }

  Future<void> _cargarHorario() async {
    final vm = context.read<HorarioViewModel>();
    final horario = await vm.cargarHorario();
    if (horario == null || !mounted) return;

    final diasGuardados = horario.diasAtencion.split(',').toSet();
    setState(() {
      _diasSeleccionados = {
        for (final k in _diasSeleccionados.keys) k: diasGuardados.contains(k),
      };
      _horaInicioCtrl.text  = horario.horaInicio;
      _horaFinCtrl.text     = horario.horaFin;
      _pausaInicioCtrl.text = horario.pausaInicio ?? '';
      _pausaFinCtrl.text    = horario.pausaFin ?? '';
      _vigenciaDesde        = horario.vigenciaDesde;
    });
  }

  @override
  void dispose() {
    _horaInicioCtrl.dispose();
    _horaFinCtrl.dispose();
    _pausaInicioCtrl.dispose();
    _pausaFinCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // GUARDAR
  // ─────────────────────────────────────────

  Future<void> _guardar() async {
    final vm = context.read<HorarioViewModel>();
    final diasActivos = _diasSeleccionados.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final exito = await vm.guardarHorario(
      diasSeleccionados: diasActivos,
      horaInicio:   _horaInicioCtrl.text,
      horaFin:      _horaFinCtrl.text,
      duracionCita: 20, // Siempre 20 minutos
      pausaInicio:  _pausaInicioCtrl.text.isEmpty ? null : _pausaInicioCtrl.text,
      pausaFin:     _pausaFinCtrl.text.isEmpty    ? null : _pausaFinCtrl.text,
      vigenciaDesde: _vigenciaDesde,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exito
            ? vm.successMessage ?? 'Horario guardado correctamente'
            : vm.errorMessage  ?? 'Error al guardar'),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );
  }

  // ─────────────────────────────────────────
  // TIME PICKER
  // ─────────────────────────────────────────

  Future<void> _seleccionarHora(TextEditingController ctrl) async {
    final partes = ctrl.text.split(':');
    final inicial = TimeOfDay(
      hour:   int.tryParse(partes[0]) ?? 8,
      minute: int.tryParse(partes[1]) ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: inicial,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.btnGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  // DATE PICKER
  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _vigenciaDesde,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.btnGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _vigenciaDesde = picked);
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HorarioViewModel>();

    final vigenciaTexto =
        '${_vigenciaDesde.day.toString().padLeft(2, '0')}/'
        '${_vigenciaDesde.month.toString().padLeft(2, '0')}/'
        '${_vigenciaDesde.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(title: "Inicio / Configuración / Horarios"),

          // Botón Volver
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.btnGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Volver",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          // Tarjeta principal
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 500),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Título
                            const Text(
                              "Configuración de Horario",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Define tu disponibilidad semanal",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 25),

                            // ── Días ──
                            _tituloSeccion("Días de Atención"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _diasSeleccionados.keys.map((dia) {
                                return _buildDayCircle(dia);
                              }).toList(),
                            ),

                            const SizedBox(height: 25),

                            // ── Horario General ──
                            _tituloSeccion("Horario General"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: _campoTime("Inicio", _horaInicioCtrl)),
                                const SizedBox(width: 15),
                                Expanded(child: _campoTime("Fin", _horaFinCtrl)),
                              ],
                            ),

                            const SizedBox(height: 25),

                            // ── Pausa ──
                            _tituloSeccion("Pausa / Almuerzo"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                    child: _campoTime(
                                        "Inicio Pausa", _pausaInicioCtrl)),
                                const SizedBox(width: 15),
                                Expanded(
                                    child:
                                        _campoTime("Fin Pausa", _pausaFinCtrl)),
                              ],
                            ),

                            const SizedBox(height: 25),

                            // ── Vigencia ──
                            _tituloSeccion("Vigencia desde"),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _seleccionarFecha,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 20, color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Text(vigenciaTexto,
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // ── Botones ──
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancelar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.btnGreen,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    onPressed: vm.isLoading ? null : _guardar,
                                    child: vm.isLoading
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.black),
                                          )
                                        : const Text("Guardar Cambios",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // WIDGETS AUXILIARES (diseño original intacto)
  // ─────────────────────────────────────────

  Widget _buildDayCircle(String dia) {
    final isSelected = _diasSeleccionados[dia]!;
    return GestureDetector(
      onTap: () => setState(() => _diasSeleccionados[dia] = !isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.btnGreen : Colors.grey[200],
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.green.shade700, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          dia,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _tituloSeccion(String texto) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 4,
          decoration: BoxDecoration(
            color: AppColors.btnGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(texto,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _campoTime(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () => _seleccionarHora(controller),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            prefixIcon:
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueGrey),
            ),
          ),
        ),
      ],
    );
  }
}