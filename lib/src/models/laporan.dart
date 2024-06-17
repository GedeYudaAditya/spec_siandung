class Laporan {
  Laporan({
    this.id,
    this.idKlarifikasi,
    this.klarifikasi,
    this.keterangan,
    this.dateCreated,
  });

  String? id;
  String? idKlarifikasi;
  String? klarifikasi;
  String? keterangan;
  String? dateCreated;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        id: json["id_laporan"],
        idKlarifikasi: json["id_klasifikasi"],
        klarifikasi: json["klasifikasi"],
        keterangan: json["keterangan"],
        dateCreated: json["date_created"],
      );

  Map<String, dynamic> toJson() => {
        "id_laporan": id,
        "id_klarifikasi": idKlarifikasi,
        "klarifikasi": klarifikasi,
        "keterangan": keterangan,
        "date_created": dateCreated,
      };

  static List<Laporan> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Laporan.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Laporan> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
