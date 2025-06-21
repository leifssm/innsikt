import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'party.mapper.dart';

const defaultPartyColor = Colors.purple;

const partyColors = {
  'ALP': null,
  'B': null,
  'DNF': null,
  'FFF': null,
  'Kp': null,
  'NKP': null,
  'RV': null,
  'SF': null,
  'SVf': null,
  'TF': null,
  'Uav': Colors.blueGrey,
  'PF': Color(0xFFF95731),
  'FrP': Color(0xFF192A58),
  'H': Color(0xFF4179BF),
  'V': Color(0xFF0C462E),
  'KrF': Color(0xFFF7A528),
  'MDG': Color(0xFF89C041),
  'Sp': Color(0xFF15994B),
  'A': Color(0xFFCE262C),
  'SV': Color(0xFFA61D5F),
  'R': Color(0xFF6A1E44),
};

Color partyColorFromId([String? id]) {
  if (id == null) return defaultPartyColor;
  return partyColors[id] ?? defaultPartyColor;
}

const partySorting = [
  'Uav',
  'ALP',
  'B',
  'DNF',
  'FFF',
  'Kp',
  'NKP',
  'RV',
  'SF',
  'SVf',
  'TF',
  'PF',
  'FrP',
  'H',
  'V',
  'KrF',
  'MDG',
  'Sp',
  'A',
  'SV',
  'R',
];

@MappableClass()
class Party with PartyMappable implements Comparable<Party> {
  /// Element som definerer identifikator for partiet
  final String id;

  /// Element som definerer navnet til partiet
  @MappableField(key: 'navn')
  final String name;
  
  final Color color;

  Party({
    required this.id,
    required this.name,
  }) : 
    color = partyColorFromId(id);

  @override
  int compareTo(Party other) {
    final thisIndex = partySorting.indexOf(id);
    final otherIndex = partySorting.indexOf(other.id);
    
    return thisIndex.compareTo(otherIndex);
  }

  static final fromJson = PartyMapper.fromJson;
}
