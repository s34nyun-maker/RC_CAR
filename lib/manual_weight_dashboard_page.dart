import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManualWeightDashboardPage extends StatefulWidget {
  const ManualWeightDashboardPage({super.key});

  @override
  State<ManualWeightDashboardPage> createState() => _ManualWeightDashboardPageState();
}

class _ManualWeightDashboardPageState extends State<ManualWeightDashboardPage> {
  // Color Palette according to Stitch design system
  static const Color colorBackground = Color(0xFF131313);
  static const Color colorSurface = Color(0xFF201F1F);
  static const Color colorSurfaceHigh = Color(0xFF2A2A2A);
  static const Color colorSurfaceHighest = Color(0xFF353534);
  static const Color colorPrimary = Color(0xFFFF5F00); // Neon Orange
  static const Color colorSecondary = Color(0xFF05E777); // Race Green
  static const Color colorTextOnBackground = Color(0xFFE5E2E1);
  static const Color colorTextVariant = Color(0xFFE4BFB1);
  static const Color colorOutline = Color(0xFFAB8A7D);

  final TextEditingController _flController = TextEditingController(text: '327.0');
  final TextEditingController _frController = TextEditingController(text: '334.2');
  final TextEditingController _rlController = TextEditingController(text: '333.0');
  final TextEditingController _rrController = TextEditingController(text: '329.0');

  double _totalWeight = 0.0;
  double _crossWeightPerc = 0.0;
  double _flRatio = 0.0;
  double _frRatio = 0.0;
  double _rlRatio = 0.0;
  double _rrRatio = 0.0;
  double _frontRatio = 0.0;
  double _rearRatio = 0.0;
  double _leftRatio = 0.0;
  double _rightRatio = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateBalance();
  }

  void _calculateBalance() {
    final double fl = double.tryParse(_flController.text) ?? 0.0;
    final double fr = double.tryParse(_frController.text) ?? 0.0;
    final double rl = double.tryParse(_rlController.text) ?? 0.0;
    final double rr = double.tryParse(_rrController.text) ?? 0.0;

    final double total = fl + fr + rl + rr;

    setState(() {
      _totalWeight = total;
      if (total > 0) {
        _flRatio = (fl / total) * 100;
        _frRatio = (fr / total) * 100;
        _rlRatio = (rl / total) * 100;
        _rrRatio = (rr / total) * 100;

        _crossWeightPerc = ((fl + rr) / total) * 100;
        _frontRatio = ((fl + fr) / total) * 100;
        _rearRatio = 100.0 - _frontRatio;
        _leftRatio = ((fl + rl) / total) * 100;
        _rightRatio = 100.0 - _leftRatio;
      } else {
        _flRatio = 0.0;
        _frRatio = 0.0;
        _rlRatio = 0.0;
        _rrRatio = 0.0;
        _crossWeightPerc = 0.0;
        _frontRatio = 0.0;
        _rearRatio = 0.0;
        _leftRatio = 0.0;
        _rightRatio = 0.0;
      }
    });
  }

  void _clearFields() {
    _flController.clear();
    _frController.clear();
    _rlController.clear();
    _rrController.clear();
    _calculateBalance();
  }

  @override
  void dispose() {
    _flController.dispose();
    _frController.dispose();
    _rlController.dispose();
    _rrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorBackground.withOpacity(0.8),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.settings_input_component, color: colorPrimary),
            const SizedBox(width: 8),
            Text(
              'CAR WEIGHT',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                color: colorPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorSurfaceHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            alignment: Alignment.center,
            child: const Text(
              'MANUAL INPUT MODE',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: colorTextVariant,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grid for Telemetry widgets (Total Weight & Cross Weight)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'TOTAL WEIGHT',
                      value: '${_totalWeight.toStringAsFixed(1)}g',
                      subTitle: 'TARGET',
                      subValue: '1320.0g',
                      valueColor: colorPrimary,
                      icon: Icons.monitor_weight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCrossWeightCard(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Visual Chassis and Inputs Area
              LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth;
                  double chassisHeight = 280;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: colorSurface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Chassis Outline CustomPainter
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.4,
                            child: CustomPaint(
                              painter: ChassisPainter(
                                strokeColor: colorPrimary.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),

                        // Corner Input Box overlays
                        SizedBox(
                          height: chassisHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Front Row (FL / FR)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCornerInputCard(
                                    label: 'Front Left (g)',
                                    controller: _flController,
                                    ratio: _flRatio,
                                    alignLeft: true,
                                  ),
                                  _buildCornerInputCard(
                                    label: 'Front Right (g)',
                                    controller: _frController,
                                    ratio: _frRatio,
                                    alignLeft: false,
                                  ),
                                ],
                              ),
                              // Rear Row (RL / RR)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCornerInputCard(
                                    label: 'Rear Left (g)',
                                    controller: _rlController,
                                    ratio: _rlRatio,
                                    alignLeft: true,
                                  ),
                                  _buildCornerInputCard(
                                    label: 'Rear Right (g)',
                                    controller: _rrController,
                                    ratio: _rrRatio,
                                    alignLeft: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Balance Distribution Panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BALANCE DISTRIBUTION',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorTextVariant,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBalanceBar(
                      label: 'FRONT / REAR',
                      valueText: '${_frontRatio.toStringAsFixed(1)}% / ${_rearRatio.toStringAsFixed(1)}%',
                      ratio: _frontRatio / 100.0,
                    ),
                    const SizedBox(height: 16),
                    _buildBalanceBar(
                      label: 'LEFT / RIGHT',
                      valueText: '${_leftRatio.toStringAsFixed(1)}% / ${_rightRatio.toStringAsFixed(1)}%',
                      ratio: _leftRatio / 100.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: _clearFields,
                      icon: const Icon(Icons.backspace_outlined, size: 16),
                      label: const Text('CLEAR ALL'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorPrimary,
                        side: const BorderSide(color: colorPrimary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Store Setup action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Setup saved successfully.'),
                            backgroundColor: colorSecondary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('STORE SETUP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorSurface,
        selectedItemColor: colorPrimary,
        unselectedItemColor: colorTextVariant.withOpacity(0.5),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_outlined),
            activeIcon: Icon(Icons.sync),
            label: 'Sync',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subTitle,
    required String subValue,
    required Color valueColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(icon, color: colorTextVariant.withOpacity(0.08), size: 36),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: colorTextVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.05), height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    subValue,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorTextOnBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCrossWeightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CROSS WEIGHT %',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: colorTextVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _crossWeightPerc.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '%',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: colorOutline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _crossWeightPerc > 0 ? _crossWeightPerc / 100 : 0.0,
              backgroundColor: colorSurfaceHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(colorSecondary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCornerInputCard({
    required String label,
    required TextEditingController controller,
    required double ratio,
    required bool alignLeft,
  }) {
    return Container(
      width: 135,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorSurface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorTextOnBackground,
            ),
            textAlign: alignLeft ? TextAlign.left : TextAlign.right,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onChanged: (val) => _calculateBalance(),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RATIO',
                  style: TextStyle(fontSize: 8, color: colorOutline, fontFamily: 'monospace'),
                ),
                Text(
                  '${ratio.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBalanceBar({
    required String label,
    required String valueText,
    required double ratio,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: Colors.grey,
              ),
            ),
            Text(
              valueText,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorTextOnBackground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio.isNaN ? 0.0 : ratio,
            backgroundColor: colorSurfaceHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(colorPrimary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// Draw a schematic sports car outline
class ChassisPainter extends CustomPainter {
  final Color strokeColor;

  ChassisPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintOutline = Paint()
      ..color = strokeColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Sleek cockpit / body shape
    final Path bodyPath = Path();
    double centerX = size.width / 2;
    double topY = size.height * 0.15;
    double bottomY = size.height * 0.85;
    double widthOffset = size.width * 0.22;

    bodyPath.moveTo(centerX, topY);
    bodyPath.quadraticBezierTo(centerX + widthOffset * 0.8, topY + 4, centerX + widthOffset * 0.8, size.height * 0.3);
    bodyPath.lineTo(centerX + widthOffset * 0.6, size.height * 0.45);
    bodyPath.quadraticBezierTo(centerX + widthOffset * 0.9, size.height * 0.65, centerX + widthOffset * 0.7, bottomY);
    bodyPath.lineTo(centerX - widthOffset * 0.7, bottomY);
    bodyPath.quadraticBezierTo(centerX - widthOffset * 0.9, size.height * 0.65, centerX - widthOffset * 0.6, size.height * 0.45);
    bodyPath.lineTo(centerX - widthOffset * 0.8, size.height * 0.3);
    bodyPath.quadraticBezierTo(centerX - widthOffset * 0.8, topY + 4, centerX, topY);
    bodyPath.close();

    canvas.drawPath(bodyPath, paintOutline);

    // Axles
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.3),
      Paint()
        ..color = strokeColor.withOpacity(0.12)
        ..strokeWidth = 2.0,
    );

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.85, size.height * 0.7),
      Paint()
        ..color = strokeColor.withOpacity(0.12)
        ..strokeWidth = 2.0,
    );

    // Draw Wheel Hubs / Tires
    final tirePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    final tireOutline = Paint()
      ..color = strokeColor.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double tireW = size.width * 0.14;
    double tireH = size.height * 0.16;

    final wheelCenters = [
      Offset(size.width * 0.15, size.height * 0.3), // FL
      Offset(size.width * 0.85, size.height * 0.3), // FR
      Offset(size.width * 0.15, size.height * 0.7), // RL
      Offset(size.width * 0.85, size.height * 0.7), // RR
    ];

    for (var center in wheelCenters) {
      final RRect tire = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: tireW, height: tireH),
        const Radius.circular(4),
      );
      canvas.drawRRect(tire, tirePaint);
      canvas.drawRRect(tire, tireOutline);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
