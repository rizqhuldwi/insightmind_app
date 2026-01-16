// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminSettingsAdapter extends TypeAdapter<AdminSettings> {
  @override
  final int typeId = 6;

  @override
  AdminSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminSettings(
      broadcastMessage: fields[0] as String,
      lowRiskRecommendation: fields[1] as String,
      mediumRiskRecommendation: fields[2] as String,
      highRiskRecommendation: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdminSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.broadcastMessage)
      ..writeByte(1)
      ..write(obj.lowRiskRecommendation)
      ..writeByte(2)
      ..write(obj.mediumRiskRecommendation)
      ..writeByte(3)
      ..write(obj.highRiskRecommendation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
