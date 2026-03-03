import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/citas_viewmodel.dart';
import 'package:sistema_citas_medicas/features/pacientes/models/paciente_model.dart';
import 'package:sistema_citas_medicas/core/theme/app_colors.dart';

class PacienteSelector extends StatefulWidget {
  const PacienteSelector({super.key});

  @override
  State<PacienteSelector> createState() => _PacienteSelectorState();
}

class _PacienteSelectorState extends State<PacienteSelector> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    _cerrarDropdown();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // OVERLAY (el dropdown flotante)
  // ─────────────────────────────────────────

  void _abrirDropdown() {
    if (_isOpen) return;
    _isOpen = true;

    final vm = context.read<CitaViewModel>();
    vm.filtrarPacientes(''); // Muestra todos al abrir

    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _cerrarDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _toggleDropdown() {
    _isOpen ? _cerrarDropdown() : _abrirDropdown();
  }

  void _seleccionarPaciente(PacienteModel paciente) {
    final vm = context.read<CitaViewModel>();
    vm.setPaciente(paciente);
    _searchController.text = "${paciente.nombres} ${paciente.apellidos}";
    _cerrarDropdown();
  }

  void _onSearchChanged(String query) {
    final vm = context.read<CitaViewModel>();
    vm.filtrarPacientes(query);
    // Refresca el overlay con los nuevos resultados
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _buildOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        final vm = Provider.of<CitaViewModel>(context);
        final pacientes = vm.pacientesFiltrados;

        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.fieldBlue.withOpacity(0.4)),
                ),
                child: pacientes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "No se encontraron pacientes",
                          style: TextStyle(color: Colors.black45, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shrinkWrap: true,
                        itemCount: pacientes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (_, i) {
                          final p = pacientes[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _seleccionarPaciente(p),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 18, color: Colors.black45),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${p.nombres} ${p.apellidos}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "CI: ${p.cedula}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitaViewModel>();

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        // Cerrar al tocar fuera
        onTap: _isOpen ? _cerrarDropdown : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de búsqueda
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.fieldBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.person_search, size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        _onSearchChanged(v);
                        if (!_isOpen) _abrirDropdown();
                      },
                      onTap: _abrirDropdown,
                      decoration: const InputDecoration(
                        hintText: "Buscar por nombre o cédula...",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                  // Botón flecha para abrir/cerrar
                  GestureDetector(
                    onTap: _toggleDropdown,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chip del paciente seleccionado
            if (vm.pacienteSeleccionado != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.btnGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.btnGreen.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      "${vm.pacienteSeleccionado!.nombres} ${vm.pacienteSeleccionado!.apellidos}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        vm.setPaciente(null);
                        _searchController.clear();
                      },
                      child: const Icon(Icons.close, size: 14, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}