import 'package:flutter/material.dart';
import 'package:medicalarm/entity/dose_receiver.dart';

// 服用者の識別色パレット。デザインモック (issue #277) の #4678C8 / #B96A4A を含む低彩度・中明度の6色で、
// 白文字を載せる前提のためパステル等の高明度色は含めない
const List<Color> _doseReceiverIdentificationColors = [
  Color(0xFF4678C8),
  Color(0xFFB96A4A),
  Color(0xFF3E8B85),
  Color(0xFF8B6BB5),
  Color(0xFF55885C),
  Color(0xFFB05C86),
];

/// [DoseReceiver.id] から識別色を決定的に割り当てる。同じ服用者は全画面で同じ色になる。
Color doseReceiverIdentificationColor({required String doseReceiverID}) {
  // String.hashCode は実行環境間で安定が保証されないため、コード単位の畳み込みで安定ハッシュを作る
  var hash = 0;
  for (final codeUnit in doseReceiverID.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  return _doseReceiverIdentificationColors[hash % _doseReceiverIdentificationColors.length];
}

/// 服用者名の先頭1文字 + 識別色の円形アバター。「誰の薬か」を色で判別するための表示。
class DoseReceiverAvatar extends StatelessWidget {
  /// 表示対象の服用者。識別色は [DoseReceiver.id]、頭文字は [DoseReceiver.name] から決まる。
  final DoseReceiver doseReceiver;

  /// アバターの直径。フォントサイズもこの値から比率で決まる。
  final double size;

  const DoseReceiverAvatar({super.key, required this.doseReceiver, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: doseReceiverIdentificationColor(doseReceiverID: doseReceiver.id),
        shape: BoxShape.circle,
      ),
      child: Text(
        doseReceiver.name.isEmpty ? '' : doseReceiver.name.characters.first,
        style: TextStyle(
          // デザインモックの比率 (32px アバターに fontSize 15) に合わせる
          fontSize: size * 15 / 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
