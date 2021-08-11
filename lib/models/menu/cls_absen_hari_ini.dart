import 'dart:convert';

ModelAbsenHariIni modelAbsenHariIniFromJson(String? str) =>
    ModelAbsenHariIni.fromJson(json.decode(str!));

String? modelAbsenHariIniToJson(ModelAbsenHariIni data) =>
    json.encode(data.toJson());

class ModelAbsenHariIni {
  ModelAbsenHariIni({
    this.statusJson,
    this.remarks,
    this.hari,
    this.tanggal,
    this.bulantahun,
    this.absenIn,
    this.absenOut,
  });

  bool? statusJson;
  String? remarks;
  String? hari;
  String? tanggal;
  String? bulantahun;
  Absen? absenIn;
  Absen? absenOut;

  factory ModelAbsenHariIni.fromJson(Map<String, dynamic> json) =>
      ModelAbsenHariIni(
        statusJson: json["status_json"],
        remarks: json["remarks"],
        hari: json["hari"],
        tanggal: json["tanggal"],
        bulantahun: json["bulantahun"],
        absenIn:
            json["absen_in"] == null ? null : Absen.fromJson(json["absen_in"]),
        absenOut: json["absen_out"] == null
            ? null
            : Absen.fromJson(json["absen_out"]),
      );

  Map<String, dynamic> toJson() => {
        "status_json": statusJson,
        "remarks": remarks,
        "absen_in": absenIn!.toJson(),
        "absen_out": absenOut!.toJson(),
      };
}

class Absen {
  Absen({
    this.id,
    this.iduser,
    this.tipeAbsen,
    this.datangPulang,
    this.wfhWfo,
    this.tanggalAbsen,
    this.jamAbsen,
    this.lokasi,
    this.latitude,
    this.longitude,
    this.keterangan,
  });

  String? id;
  String? iduser;
  String? tipeAbsen;
  String? datangPulang;
  String? wfhWfo;
  String? tanggalAbsen;
  String? jamAbsen;
  String? lokasi;
  String? latitude;
  String? longitude;
  dynamic keterangan;

  factory Absen.fromJson(Map<String, dynamic> json) => Absen(
        id: json["id"],
        iduser: json["iduser"],
        tipeAbsen: json["tipe_absen"],
        datangPulang: json["datang_pulang"],
        wfhWfo: json["wfh_wfo"],
        tanggalAbsen: json["tanggal_absen"],
        jamAbsen: json["jam_absen"],
        lokasi: json["lokasi"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "iduser": iduser,
        "tipe_absen": tipeAbsen,
        "datang_pulang": datangPulang,
        "wfh_wfo": wfhWfo,
        "tanggal_absen": tanggalAbsen,
        "jam_absen": jamAbsen,
        "lokasi": lokasi,
        "latitude": latitude,
        "longitude": longitude,
        "keterangan": keterangan,
      };
}
