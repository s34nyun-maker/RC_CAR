import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightInputPage extends StatefulWidget {
  const WeightInputPage({super.key});

  @override
  State<WeightInputPage> createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  // Theme colors matching Stitch Design
  static const Color colorBackground = Color(0xFF131313);
  static const Color colorSurface = Color(0xFF201F1F);
  static const Color colorSurfaceHigh = Color(0xFF2A2A2A);
  static const Color colorSurfaceHighest = Color(0xFF353534);
  static const Color colorPrimary = Color(0xFFFF5F00); // Neon Orange
  static const Color colorSecondary = Color(0xFF05E777); // Race Green / Secondary Container
  static const Color colorTextOnBackground = Color(0xFFE5E2E1);
  static const Color colorTextVariant = Color(0xFFE4BFB1);
  static const Color colorOutline = Color(0xFFAB8A7D);

  final TextEditingController _flController = TextEditingController(text: '342.0');
  final TextEditingController _frController = TextEditingController(text: '338.0');
  final TextEditingController _rlController = TextEditingController(text: '341.0');
  final TextEditingController _rrController = TextEditingController(text: '340.0');

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

  bool _isCalibrating = false;

  @override
  void initState() {
    super.initState();
    _calculateWeights();
  }

  void _calculateWeights() {
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
        _rearRatio = 100 - _frontRatio;
        _leftRatio = ((fl + rl) / total) * 100;
        _rightRatio = 100 - _leftRatio;
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

  void _handleZeroCalibration() {
    setState(() {
      _isCalibrating = true;
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _flController.text = '0.0';
          _frController.text = '0.0';
          _rlController.text = '0.0';
          _rrController.text = '0.0';
          _isCalibrating = false;
          _calculateWeights();
        });
      }
    });
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
        backgroundColor: colorBackground,
        elevation: 0,
        leading: const Icon(Icons.settings_input_component, color: colorPrimary),
        title: const Text(
          'PADDOCK PRO',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: colorPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.bluetooth_connected, color: colorPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Scale Link & Zero Calibration Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorSurface,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SCALE LINK',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: colorTextVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorSecondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorSecondary.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'CONNECTED',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _isCalibrating ? null : _handleZeroCalibration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorSurfaceHigh,
                        foregroundColor: colorTextOnBackground,
                        disabledBackgroundColor: colorSurfaceHigh.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: Text(
                        _isCalibrating ? 'CALIBRATING...' : 'ZERO CALIBRATION',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Corner Weight 2x2 Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.25,
                children: [
                  _buildCornerInputCard(
                    title: 'FL (Front-Left)',
                    controller: _flController,
                    ratio: _flRatio,
                  ),
                  _buildCornerInputCard(
                    title: 'FR (Front-Right)',
                    controller: _frController,
                    ratio: _frRatio,
                  ),
                  _buildCornerInputCard(
                    title: 'RL (Rear-Left)',
                    controller: _rlController,
                    ratio: _rlRatio,
                  ),
                  _buildCornerInputCard(
                    title: 'RR (Rear-Right)',
                    controller: _rrController,
                    ratio: _rrRatio,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Real-time Preview & Metrics Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorSurface,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL WEIGHT',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: colorTextVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _totalWeight.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: colorTextOnBackground,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' g',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 16,
                                      color: colorTextVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'CROSS WEIGHT',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: colorTextVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_crossWeightPerc.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 3.5,
                        children: [
                          _buildBalanceRow('FRONT', '${_frontRatio.toStringAsFixed(1)}%'),
                          _buildBalanceRow('REAR', '${_rearRatio.toStringAsFixed(1)}%'),
                          _buildBalanceRow('LEFT', '${_leftRatio.toStringAsFixed(1)}%'),
                          _buildBalanceRow('RIGHT', '${_rightRatio.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Setup Captured!'),
                            backgroundColor: colorPrimary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('CAPTURE SETUP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
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
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Garage',
          ),
        ],
      ),
    );
  }

  Widget _buildCornerInputCard({
    required String title,
    required TextEditingController controller,
    required double ratio,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorSurfaceHigh,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: colorTextVariant,
                ),
              ),
              Icon(Icons.monitor_weight_outlined, size: 14, color: colorPrimary.withOpacity(0.4)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onChanged: (val) => _calculateWeights(),
                ),
                const Positioned(
                  right: 0,
                  bottom: 4,
                  child: Text(
                    'g',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: colorTextVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: ratio > 0 ? ratio / 100 : 0.0,
                    backgroundColor: colorSurfaceHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(colorPrimary),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${ratio.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: colorTextVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String valueText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: colorTextVariant,
            ),
          ),
          Text(
            valueText,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorTextOnBackground,
            ),
          ),
        ],
      ),
    );
  }
}
