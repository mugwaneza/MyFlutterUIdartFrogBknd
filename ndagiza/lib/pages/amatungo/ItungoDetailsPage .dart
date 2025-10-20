import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/statics/ApiUrls.dart';

// Main Stateful Widget
class ItungoDetailsPage extends StatefulWidget {
  final Map<String, dynamic> clickedItem;

  const ItungoDetailsPage({Key? key, required this.clickedItem})
      : super(key: key);

  @override
  State<ItungoDetailsPage> createState() => _ItungoDetailsPageState();
}

class _ItungoDetailsPageState extends State<ItungoDetailsPage> {
  late Itungo itungo;
  List<Map<String, dynamic>> ItungoImyororokereList = [];

  @override
  void initState() {
    super.initState();

    fetchItungoImyororokereList();
    // Debug print
    print("Clicked item itunguui: ${widget.clickedItem['itunguui']}");
  }

  Future<void> fetchItungoImyororokereList() async {
    try {
      final itunguui = widget.clickedItem['itunguui']?.toString() ?? '';
      if (itunguui.isEmpty) return;
      final response =
          await http.get(Uri.parse(ApiUrls.ImyorkrList + '$itunguui'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List ? decoded : [];

        setState(() {
          ItungoImyororokereList = data
              .map((item) => {
                    'itunguui': item['itunguui']?.toString() ?? '',
                    'itunguui_imyruui':
                        item['itunguui_imyruui']?.toString() ?? '',
                    'igitsina': item['igitsina']?.toString() ?? '',
                    'ibara': item['ibara']?.toString() ?? '',
                    'ifoto_url': item['ifoto_url']?.toString() ?? '',
                    'ubukure': item['ubukure']?.toString() ?? '',
                    'itngcode': item['itngcode']?.toString() ?? '',
                    'ibiro': item['ibiro']?.toString() ?? '',
                    'ahoryavuye': item['ahoryavuye']?.toString() ?? '',
                    'igihe': item['igihe']?.toString() ?? '',
                    'ukozruui': item['ukozruui']?.toString() ?? '',
                    'amezi_rihaka': item['amezi_rihaka']?.toString() ?? '',
                    'itariki_ryimiye':
                        item['itariki_ryimiye']?.toString() ?? '',
                    'itariki_ribyariye':
                        item['itariki_ribyariye']?.toString() ?? '',
                    'itariki_ariherewe':
                        item['itariki_ariherewe']?.toString() ?? '',
                    'itariki_aryakiwe':
                        item['itariki_aryakiwe']?.toString() ?? '',
                    'igitsina_cyavutse':
                        item['igitsina_cyavutse']?.toString() ?? '',
                    'uzmuui': item['uzmuui']?.toString() ?? '',
                    'amafaranga_yarigiyeho':
                        item['amafaranga_yarigiyeho']?.toString() ?? '',
                    'amafaranga_ryinjije':
                        item['amafaranga_ryinjije']?.toString() ?? '',
                    'ibisobanuro': item['ibisobanuro']?.toString() ?? '',
                    'itariki_byabereyeho':
                        item['itariki_byabereyeho']?.toString() ?? '',
                    'amafaranga_rihagaze':
                        item['amafaranga_rihagaze']?.toString() ?? '',
                    'itariki_yaguriwe':
                        item['itariki_yaguriwe']?.toString() ?? '',
                    'iskuui': item['iskuui']?.toString() ?? '',
                    'ubwokobwitungo': item['ubwokobwitungo']?.toString() ?? '',
                    'ameziibyarira': item['ameziibyarira']?.toString() ?? '',
                    'imyakayokororoka':
                        item['imyakayokororoka']?.toString() ?? '',
                    'izina_uhagarariye':
                        item['izina_uhagarariye']?.toString() ?? '',
                    'irindi_zina_uhagarariye':
                        item['irindi_zina_uhagarariye']?.toString() ?? '',
                    'telephone_uhagarariye':
                        item['telephone_uhagarariye']?.toString() ?? '',
                    'inshingano_uhagarariye':
                        item['inshingano_uhagarariye']?.toString() ?? '',
                    'aho_atuye_uhagarariye':
                        item['aho_atuye_uhagarariye']?.toString() ?? '',
                    'izina_uworoye': item['izina_uworoye']?.toString() ?? '',
                    'irindi_zina_uworoye':
                        item['irindi_zina_uworoye']?.toString() ?? '',
                    'telephone_uworoye':
                        item['telephone_uworoye']?.toString() ?? '',
                    'inshingano_uworoye':
                        item['inshingano_uworoye']?.toString() ?? '',
                    'aho_atuye_uworoye':
                        item['aho_atuye_uworoye']?.toString() ?? '',
                  })
              .toList();

          // Initialize Itungo from clickedItem
          if (ItungoImyororokereList.isNotEmpty) {
            final firstItem = ItungoImyororokereList[0];

            // Parse the date
            DateTime? bleedingDate;
            if (firstItem['itariki_ryimiye'] != null) {
              bleedingDate = DateTime.tryParse(firstItem['itariki_ryimiye']);
            }

            int monthsToAdd =
                int.tryParse(firstItem['ameziibyarira']?.toString() ?? '') ?? 0;
            print('moths>> $monthsToAdd');

            // Calculate expected birth date
            String expectedBirthDate = 'N/A';
            if (bleedingDate != null &&
                monthsToAdd > 0 &&
                (firstItem['igitsina']?.toUpperCase() == 'FEMALE' ||
                    firstItem['igitsina']?.toUpperCase() == 'GORE')) {
              DateTime birthDate = DateTime(
                bleedingDate.year,
                bleedingDate.month + monthsToAdd,
                bleedingDate.day,
              );

              expectedBirthDate =
                  "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";
            }

            // now map into Itungo model
            itungo = Itungo(
              //id: firstItem['itunguui'] ?? 'N/A',
              ubwoko: firstItem['ubwokobwitungo'] ?? 'N/A',
              igitsina: firstItem['igitsina'] ?? 'N/A',
              code: firstItem['itngcode'] ?? 'N/A',
              igiciro: firstItem['amafaranga_rihagaze'] ?? 'N/A',
              igiheRyaziy: firstItem['igihe'] ?? 'N/A',
              ameziibyarira: firstItem['ameziibyarira'] ?? 'N/A',
              igiheRyimiye: firstItem['itariki_ryimiye'] ?? 'N/A',
              igiheRizimira: 'N/A',
              igiheRizabyarira: expectedBirthDate,
              ubukure: firstItem['ubukure'] ?? 'N/A',
              ubuzima: 'N/A',
              itarikiUbuzima: firstItem['itariki_byabereyeho'] ?? 'N/A',
              ikibazo: firstItem['ibisobanuro'] ?? 'N/A',
              ikiguziUbuvuzi: firstItem['amafaranga_yarigiyeho'] ?? 'N/A',
              uriragiye: firstItem['izina_uworoye'] ?? 'N/A',
              ahoAtuye: firstItem['aho_atuye_uworoye'] ?? 'N/A',

              telUragiye: firstItem['telephone_uworoye'] ?? 'N/A',
              igiheYarifatiye:
                  firstItem['itariki_ariherewe'] ?? 'N/A', //itariki_yaguriwe

              umwishingizi: firstItem['izina_uhagarariye'] ?? 'N/A',
              ahoAtuyeUmwishingizi: firstItem['aho_atuye_uhagarariye'] ?? 'N/A',
              telUmwishingizi: firstItem['telephone_uhagarariye'] ?? 'N/A',
            );
          }
        });
      } else {
        print('Error fetching info: ${response.statusCode}');
      }
    } catch (e, st) {
      print('Exception fetching info: $e\n$st');
      setState(() {
        ItungoImyororokereList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //accessing `itungo` before loading finishes
    if (ItungoImyororokereList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("UKO RYOROROKA")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final List<_SectionInfo> sections = [
      _SectionInfo(
        title: 'ITUNGO',
        icon: Icons.pets,
        iconColor: Colors.orange,
        children: [
          _tableRow('UBWOKO', itungo.ubwoko, 'IGITSINA', itungo.igitsina),
          _tableRow('CODE', itungo.code, 'IGICIRO', itungo.igiciro),
          _tableSingleRow('IGIHE RYAZIYE', itungo.igiheRyaziy,
              isDate: true, color: Colors.orange),
        ],
      ),
      _SectionInfo(
        title: 'IMYOROROKERE',
        icon: Icons.egg,
        iconColor: Colors.green,
        children: [
          _tableRow('RYIMYE KU WA', itungo.igiheRyimiye, 'IGIHE CYO KWIMA',
              itungo.igiheRizimira,
              isDate1: true,
              isDate2: true,
              color: Colors.green,
              animateRight: AnimationType.pulse),
          _tableRow('IGIHE CYO KUBYARA', itungo.igiheRizabyarira, 'UBUKURE',
              itungo.ubukure,
              isDate1: true,
              color: Colors.green,
              animateLeft: AnimationType.colorFade),
        ],
      ),
      _SectionInfo(
        title: 'UBUZIMA BWARYO',
        icon: Icons.health_and_safety,
        iconColor: Colors.red,
        children: [
          _tableRow('UBUZIMA', itungo.ubuzima, 'ITARIKI', itungo.itarikiUbuzima,
              isDate2: true, color: Colors.red),
          _tableRow('IKIBAZO', itungo.ikibazo, 'IKIGUZI CY\'UBUVUZI',
              itungo.ikiguziUbuvuzi),
        ],
      ),
      _SectionInfo(
        title: 'KURAGIZWA',
        icon: Icons.person,
        iconColor: Colors.blue,
        children: [
          _tableRow(
              'URIRAGIYE', itungo.uriragiye, 'AHO ATUYE', itungo.ahoAtuye),
          _tableRow('TEL', itungo.telUragiye, 'IGIHE YARIFATIYE',
              itungo.igiheYarifatiye,
              isDate2: true, color: Colors.blue),
          _tableRow('UMWISHINGIZI', itungo.umwishingizi, 'AHO ATUYE',
              itungo.ahoAtuyeUmwishingizi),
          _tableSingleRow('TEL UMWISHINGIZI', itungo.telUmwishingizi),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Uko Ryororoka',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          )),
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

// Animated card widget (arrow centered)
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

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 1.2);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

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

// Animation types
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
        content = SlideTransition(position: _offsetAnim, child: content);
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

// Itungo model
class Itungo {
  final String ubwoko;
  final String igitsina;
  final String code;
  final String igiciro;
  final String igiheRyaziy;
  final String ameziibyarira;
  final String igiheRyimiye;
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

  Itungo({
    required this.ubwoko,
    required this.igitsina,
    required this.code,
    required this.igiciro,
    required this.igiheRyaziy,
    required this.ameziibyarira,
    required this.igiheRyimiye,
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
