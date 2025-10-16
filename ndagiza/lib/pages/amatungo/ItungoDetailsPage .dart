import 'package:flutter/material.dart';

class ItungoDetailsPage extends StatelessWidget {
  const ItungoDetailsPage({Key? key}) : super(key: key);

  final Itungo dummyItungo = const Itungo(
    id: '1',
    ubwoko: 'IHENE',
    igitsina: 'GORE',
    code: 'IH004',
    igiciro: '50,000 Rwf',
    igiheRyaziy: '20/06/2025',
    igiheRimye: '12/01/2025',
    igiheRizimira: '26/07/2025',
    igiheRizabyarira: '30/12/2025',
    ubukure: '29 MONTHS 2 DAYS',
    ubuzima: 'RYARARWAYE',
    itarikiUbuzima: '20/04/2025',
    ikibazo: 'KUVUNIKA',
    ikiguziUbuvuzi: '40,000 RWF',
    uriragiye: 'KARANGWA CHARLES',
    ahoAtuye: 'GASABO / KIGALI / MUHIMA',
    telUragiye: '07859884984',
    igiheYarifatiye: '30/08/2025',
    umwishingizi: 'RUMUMBA JULE',
    ahoAtuyeUmwishingizi: 'GASABO / KIGALI / KACYIRU',
    telUmwishingizi: '07859884984',
  );

  @override
  Widget build(BuildContext context) {
    final List<_SectionInfo> sections = [
      _SectionInfo(
        title: 'ITUNGO',
        icon: Icons.pets,
        iconColor: Colors.orange,
        children: [
          _tableRow(
              'UBWOKO', dummyItungo.ubwoko, 'IGITSINA', dummyItungo.igitsina),
          _tableRow('CODE', dummyItungo.code, 'IGICIRO', dummyItungo.igiciro),
          _tableSingleRow('IGIHE RYAZIYE', dummyItungo.igiheRyaziy,
              isDate: true, color: Colors.orange),
        ],
      ),
      _SectionInfo(
        title: 'IMYOROROKERE',
        icon: Icons.egg,
        iconColor: Colors.green,
        children: [
          _tableRow(
            'IGIHE RIMYE',
            dummyItungo.igiheRimye,
            'IGIHE RIZIMIRA',
            dummyItungo.igiheRizimira,
            isDate1: true,
            isDate2: true,
            color: Colors.green,
            animateRight: AnimationType.pulse,
          ),
          _tableRow(
            'IGIHE RIZABYARIRA',
            dummyItungo.igiheRizabyarira,
            'UBUKURE',
            dummyItungo.ubukure,
            isDate1: true,
            color: Colors.green,
            animateLeft: AnimationType.colorFade,
          ),
        ],
      ),
      _SectionInfo(
        title: 'UBUZIMA BWARYO',
        icon: Icons.health_and_safety,
        iconColor: Colors.red,
        children: [
          _tableRow('UBUZIMA', dummyItungo.ubuzima, 'ITARIKI',
              dummyItungo.itarikiUbuzima,
              isDate2: true, color: Colors.red),
          _tableRow('IKIBAZO', dummyItungo.ikibazo, 'IKIGUZI CY\'UBUVUZI',
              dummyItungo.ikiguziUbuvuzi),
        ],
      ),
      _SectionInfo(
        title: 'KURAGIZWA',
        icon: Icons.person,
        iconColor: Colors.blue,
        children: [
          _tableRow('URIRAGIYE', dummyItungo.uriragiye, 'AHO ATUYE',
              dummyItungo.ahoAtuye),
          _tableRow('TEL', dummyItungo.telUragiye, 'IGIHE YARIFATIYE',
              dummyItungo.igiheYarifatiye,
              isDate2: true, color: Colors.blue),
          _tableRow('UMWISHINGIZI', dummyItungo.umwishingizi, 'AHO ATUYE',
              dummyItungo.ahoAtuyeUmwishingizi),
          _tableSingleRow('TEL UMWISHINGIZI', dummyItungo.telUmwishingizi),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Itungo Details')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return _AnimatedSectionCard(section: sections[index]);
        },
      ),
    );
  }

  static Widget _tableRow(
    String label1,
    String value1,
    String label2,
    String value2, {
    bool isDate1 = false,
    bool isDate2 = false,
    Color? color,
    AnimationType? animateLeft,
    AnimationType? animateRight,
  }) =>
      Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FixedColumnWidth(12),
          2: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            children: [
              animateLeft != null
                  ? _AnimatedDateCell(label1, value1, color, animateLeft)
                  : _tableCell(label1, value1, isDate1, color),
              const SizedBox(),
              animateRight != null
                  ? _AnimatedDateCell(label2, value2, color, animateRight)
                  : _tableCell(label2, value2, isDate2, color),
            ],
          ),
        ],
      );

  static Widget _tableSingleRow(String label, String value,
          {bool isDate = false, Color? color}) =>
      Table(
        columnWidths: const {0: FlexColumnWidth(1)},
        children: [
          TableRow(
            children: [_tableCell(label, value, isDate, color)],
          ),
        ],
      );

  static Widget _tableCell(
          String label, String value, bool isDate, Color? color) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: isDate && color != null
                  ? BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
}

// Define different animation types
enum AnimationType { pulse, colorFade, bounce }

class _AnimatedDateCell extends StatefulWidget {
  final String label;
  final String value;
  final Color? color;
  final AnimationType type;

  const _AnimatedDateCell(this.label, this.value, this.color, this.type,
      {Key? key})
      : super(key: key);

  @override
  State<_AnimatedDateCell> createState() => _AnimatedDateCellState();
}

class _AnimatedDateCellState extends State<_AnimatedDateCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _colorAnim;
  late Animation<Offset> _offsetAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    switch (widget.type) {
      case AnimationType.pulse:
        _scale = Tween<double>(begin: 1.0, end: 1.1).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        break;
      case AnimationType.colorFade:
        _colorAnim = ColorTween(
                begin: widget.color?.withOpacity(0.2),
                end: widget.color?.withOpacity(0.5))
            .animate(_controller);
        break;
      case AnimationType.bounce:
        _offsetAnim = Tween<Offset>(
                begin: const Offset(0, 0), end: const Offset(0, -0.05))
            .animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.color?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(widget.value, style: const TextStyle(fontSize: 14)),
    );

    switch (widget.type) {
      case AnimationType.pulse:
        content = ScaleTransition(scale: _scale, child: content);
        break;
      case AnimationType.colorFade:
        content = AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _colorAnim.value,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(widget.value, style: const TextStyle(fontSize: 14)),
          ),
        );
        break;
      case AnimationType.bounce:
        content = SlideTransition(
          position: _offsetAnim,
          child: content,
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          content,
        ],
      ),
    );
  }
}

// Section info
class _SectionInfo {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  _SectionInfo({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });
}

// Animated card widget (same as previous, arrow centered)
class _AnimatedSectionCard extends StatefulWidget {
  final _SectionInfo section;
  const _AnimatedSectionCard({Key? key, required this.section})
      : super(key: key);

  @override
  State<_AnimatedSectionCard> createState() => _AnimatedSectionCardState();
}

class _AnimatedSectionCardState extends State<_AnimatedSectionCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 1.2);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: section.iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(section.icon, color: section.iconColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 3,
                              width: 40,
                              decoration: BoxDecoration(
                                color: section.iconColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: section.children
                            .map((child) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: child,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Centered arrow
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: section.iconColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_ios,
                        size: 16, color: section.iconColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Itungo model
class Itungo {
  final String id;
  final String ubwoko;
  final String igitsina;
  final String code;
  final String igiciro;
  final String igiheRyaziy;
  final String igiheRimye;
  final String igiheRizimira;
  final String igiheRizabyarira;
  final String ubukure;
  final String ubuzima;
  final String itarikiUbuzima;
  final String ikibazo;
  final String ikiguziUbuvuzi;
  final String uriragiye;
  final String ahoAtuye;
  final String telUragiye;
  final String igiheYarifatiye;
  final String umwishingizi;
  final String ahoAtuyeUmwishingizi;
  final String telUmwishingizi;

  const Itungo({
    required this.id,
    required this.ubwoko,
    required this.igitsina,
    required this.code,
    required this.igiciro,
    required this.igiheRyaziy,
    required this.igiheRimye,
    required this.igiheRizimira,
    required this.igiheRizabyarira,
    required this.ubukure,
    required this.ubuzima,
    required this.itarikiUbuzima,
    required this.ikibazo,
    required this.ikiguziUbuvuzi,
    required this.uriragiye,
    required this.ahoAtuye,
    required this.telUragiye,
    required this.igiheYarifatiye,
    required this.umwishingizi,
    required this.ahoAtuyeUmwishingizi,
    required this.telUmwishingizi,
  });
}
